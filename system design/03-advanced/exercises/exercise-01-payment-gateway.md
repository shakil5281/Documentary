# Exercise: Design a Payment Gateway

Time limit: 45 minutes

## Problem

Design a payment gateway similar to Stripe. The system should let merchants charge customers, handle retries safely, keep an auditable ledger, integrate with external payment processors, and support reconciliation.

## Requirements

- Merchants can create payment intents.
- Customers can complete payments using a payment method.
- The system must prevent duplicate charges.
- Payment status must be trackable.
- Webhooks should notify merchants about status changes.
- The ledger must be auditable.
- The system should support refunds.
- External processor failures must be handled safely.

## Non-functional Requirements

- Strong correctness for money movement.
- High availability for payment creation and status checks.
- Low latency for customer checkout.
- Secure storage and handling of sensitive data.
- Complete audit trail.
- Idempotent APIs.

## APIs

```text
POST /payment-intents
POST /payment-intents/{id}/confirm
GET /payment-intents/{id}
POST /refunds
POST /webhooks/provider
```

## Core Components

- API gateway
- Merchant service
- Payment intent service
- Payment orchestration service
- Idempotency store
- Ledger service
- External processor adapter
- Webhook service
- Queue
- Reconciliation worker
- Fraud/risk service
- Audit log

## Suggested Data Model

```text
merchants(id, name, status)
payment_intents(id, merchant_id, amount, currency, status, idempotency_key, created_at)
payment_attempts(id, payment_intent_id, processor, processor_ref, status, error_code)
ledger_entries(id, transaction_id, account_id, debit, credit, currency, created_at)
refunds(id, payment_intent_id, amount, status)
webhook_events(id, merchant_id, event_type, payload, delivery_status)
```

## Design Focus Areas

1. How do you prevent duplicate charges?
2. How do you model payment state transitions?
3. How do you write ledger entries safely?
4. How do you handle processor timeout after a charge may have succeeded?
5. How do you retry webhook delivery?
6. How do you reconcile internal state with processor state?
7. How do you secure sensitive payment data?

## Failure Scenarios

- Client retries the same payment request.
- Processor times out.
- Webhook delivery fails.
- Ledger write succeeds but status update fails.
- Reconciliation finds a mismatch.
- Fraud service is unavailable.

## Expected Answer

Your answer should include:

- Requirements and scale assumptions
- API design
- Payment state machine
- Ledger model
- Idempotency strategy
- External processor integration
- Retry and reconciliation strategy
- Security and compliance discussion
- Monitoring and alerts

## Stretch Questions

1. How would you support multiple payment processors?
2. How would you handle chargebacks?
3. How would you design multi-currency settlement?
4. How would you isolate merchants in a multi-tenant system?
5. How would you run a safe migration for ledger schema changes?
