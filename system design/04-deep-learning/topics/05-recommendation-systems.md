# Recommendation and Search Systems

Recommendation systems select and rank items for a user. They usually use multiple stages because ranking every possible item with a heavy model is too expensive.

## Common Stages

1. Candidate generation: quickly find hundreds or thousands of possible items.
2. Filtering: remove blocked, seen, unsafe, unavailable, or irrelevant items.
3. Ranking: score candidates using a stronger model.
4. Re-ranking: add diversity, freshness, business rules, or safety constraints.
5. Logging: record impressions, clicks, watch time, purchases, skips, and feedback.

## Architecture

```text
User Request -> Candidate Service -> Filter Service -> Ranker -> Re-ranker -> Feed
                      |                  |              |
                      v                  v              v
                Vector Index       Rules/Policy    Feature Store
```

## Features

- User features: location, language, interests, historical actions.
- Item features: category, creator, popularity, age, quality signals.
- Context features: time, device, session behavior, network type.
- Cross features: user-item interaction signals.

## Cold Start

- New user: use geography, onboarding preferences, trending items, and exploration.
- New item: use metadata, creator reputation, content embedding, and controlled exploration.

## Metrics

- Click-through rate
- Watch time
- Conversion rate
- Retention
- Diversity
- Freshness
- Complaint or hide rate
- Long-term user satisfaction

## Check Yourself

1. Why do recommendation systems use candidate generation before ranking?
2. What is the cold-start problem?
3. Why can optimizing only clicks be harmful?
4. What is the role of re-ranking?
5. What events should be logged for retraining?
