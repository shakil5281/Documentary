# Topic 7: Design — Notification System

Multi-channel delivery (push, email, SMS, in-app). Tests queues, prioritization, deduplication, and rate limiting.

---

## Requirements

### Functional
- Send notifications via: push, email, SMS, in-app
- User preferences (opt out of email, SMS only for urgent)
- Templates (order shipped, new follower, password reset)
- Delivery status tracking (sent, failed, opened)

### Non-functional
- 100M users, 1B notifications/day
- Critical notifications (OTP, security) delivered in < 30 sec
- Non-critical can be delayed/batched
- 99.9% delivery rate (excluding invalid addresses)

---

## Estimates

```
Notifications/day = 1 billion
QPS = 1B / 100K ≈ 10,000/sec (peak ~30,000)

Breakdown (typical):
  Push:  60%  → 6,000/sec
  Email: 30%  → 3,000/sec
  SMS:   10%  → 1,000/sec (most expensive)
```

---

## High-level architecture

```
Event Sources                Notification Service
(orders, social,  ──→  [API] ──→ [Priority Queue] ──→ [Router]
 security)                         │    │    │
                                    ↓    ↓    ↓
                              Push Worker  Email Worker  SMS Worker
                                    ↓    ↓    ↓
                              FCM/APNs  SendGrid  Twilio
                                    ↓
                              Delivery Tracker (DB)
```

---

## Core flow

```
1. Event arrives: { user_id, type: "new_follower", data: { follower: "Alice" } }
2. Lookup user preferences + contact info (cache)
3. Check: user opted in to this notification type?
4. Determine channels: push ✓, email ✗, in-app ✓
5. Enqueue separate jobs per channel with priority
6. Workers process → call external provider → log result
```

---

## Priority queues

Not all notifications are equal:

| Priority | Examples | SLA |
|----------|----------|-----|
| **Critical** | OTP, password reset, fraud alert | < 30 sec, SMS + push |
| **High** | Payment confirmation, delivery update | < 2 min |
| **Normal** | New follower, comment | < 15 min |
| **Low** | Marketing, digest emails | Batch hourly/daily |

```
Separate queues:
  critical_queue  → dedicated workers, always processed first
  high_queue
  normal_queue
  low_queue       → batch worker sends digest at 9am
```

---

## User preferences

```
notification_preferences (
  user_id,
  type,              -- 'new_follower', 'marketing', etc.
  push_enabled,
  email_enabled,
  sms_enabled
)

user_contacts (
  user_id,
  email,
  phone,
  push_token,        -- FCM/APNs device token
  timezone
)
```

Cache in Redis — read on every notification (hot path).

---

## Templates

```
templates (
  id,
  type,
  channel,
  subject_template,   -- "Your order {{order_id}} shipped"
  body_template
)

Render: substitute {{variables}} from event data
Store rendered content in notification log for audit
```

---

## Deduplication

Prevent sending the same notification twice (retry, duplicate events):

```
Dedup key: hash(user_id + type + entity_id + date)
Example: hash(user_123 + new_follower + follower_456 + 2024-01-15)

Before send:
  SET dedup:{key} 1 EX 86400 NX
  If NX fails → already sent today → skip
```

Critical for: "You have 5 new followers" — collapse into one digest instead of 5 pushes.

---

## Collapsing / batching

Social apps batch low-priority notifications:

```
Instead of:
  "Alice followed you"
  "Bob followed you"
  "Carol followed you"

Send one:
  "Alice, Bob, and 1 other followed you"
```

Implementation: hold normal-priority events in a buffer for 5 minutes → aggregate → single notification.

---

## Rate limiting

Protect users and providers:

| Limit | Value |
|-------|-------|
| Push per user | 30/hour |
| SMS per user | 5/day (cost) |
| Email per user | 10/day |
| Global SMS | Provider quota (Twilio limits) |

Exceeded → drop or downgrade to in-app only.

---

## Delivery tracking

```
notifications (
  id,
  user_id,
  type,
  channel,
  status,           -- pending, sent, delivered, failed, opened
  provider_id,      -- external reference
  created_at,
  sent_at
)
```

Enables: retry failed, analytics, user "notification history" screen.

**Webhook callbacks:** FCM/APNs/SendGrid report delivery/bounce → update status.

---

## Failure handling

| Failure | Action |
|---------|--------|
| Invalid push token | Mark token invalid, stop sending to it |
| Email bounce | Disable email for user, alert if hard bounce |
| SMS failure | Retry 2× with backoff, then fail |
| Provider outage | Circuit breaker, queue messages, retry when recovered |

---

## Idempotency

Event bus delivers at-least-once → same "order shipped" event twice.

**Fix:** Idempotency key = `order_id + event_type`. Check before enqueue.

---

## Check yourself

1. Why separate priority queues?
2. How does deduplication work for notifications?
3. Why batch/collapse social notifications?
4. What rate limits would you set and why?
5. How do you handle invalid push tokens?

## Key takeaway

**Route → prioritize → deduplicate → rate-limit → deliver → track.** Never block the main app on notification delivery — always async via queues.
