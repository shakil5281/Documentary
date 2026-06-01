# Intro to ML and Deep Learning Systems

ML system design is different from normal backend design because the main behavior comes from data and models, not only from code. A normal service returns deterministic business logic. An ML service returns predictions, rankings, embeddings, classifications, recommendations, or generated content.

## Core Components

- Data sources: application events, user actions, labels, documents, images, audio, video, and metadata.
- Data pipeline: ingestion, validation, cleaning, transformation, feature generation, and storage.
- Feature store: shared feature layer for training and serving.
- Training pipeline: trains models from historical data.
- Model registry: stores model versions, metrics, approvals, and artifacts.
- Model serving: exposes models through APIs, batch jobs, or streaming systems.
- Monitoring: tracks service health and model quality.
- Feedback loop: collects new outcomes to improve the next model.

## Offline vs Online

Offline systems prepare data and train models. They optimize for correctness, volume, repeatability, and cost.

Online systems serve predictions to users. They optimize for latency, availability, safety, and graceful fallback.

## Basic Architecture

```text
User Events -> Event Stream -> Data Lake/Warehouse -> Training Pipeline -> Model Registry
                         |                              |
                         v                              v
                    Feature Store <-------------- Model Server
                         |                              |
                         +-------- Online API ----------+
```

## Important Trade-offs

- Accuracy vs latency: larger models may be better but slower.
- Freshness vs cost: real-time features are powerful but expensive.
- Personalization vs privacy: user-level data improves quality but increases risk.
- Automation vs control: automatic retraining is fast but can deploy bad models without guardrails.

## Common Failure Cases

- Training-serving skew: training features differ from online features.
- Data drift: production data changes over time.
- Label leakage: training data includes information that would not exist at prediction time.
- Silent model degradation: API is healthy but predictions are worse.
- Cold start: new users or items have little historical data.

## Check Yourself

1. Why does an ML system need both software monitoring and model monitoring?
2. What is training-serving skew?
3. Why is a feature store useful?
4. When should you use batch prediction instead of online prediction?
5. What fallback should exist if the model server is unavailable?
