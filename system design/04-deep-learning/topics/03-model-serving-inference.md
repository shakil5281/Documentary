# Model Serving and Inference at Scale

Model serving is the online layer that receives input, runs a model, and returns a prediction or generated result. It must balance latency, throughput, cost, and quality.

## Serving Patterns

- Online inference: user waits for the response.
- Batch inference: predictions are precomputed for many items.
- Streaming inference: model processes continuous events.
- Edge inference: model runs on device or near the user.

## Architecture

```text
Client -> API Gateway -> Application Service -> Feature Fetch -> Model Server -> Response
                                      |              |
                                      v              v
                                    Cache       Model Registry
```

## Optimization Techniques

- Batching: combine requests for better hardware utilization.
- Caching: reuse predictions for repeated inputs.
- Quantization: use smaller numeric precision to reduce memory and latency.
- Distillation: train a smaller model to mimic a larger one.
- Autoscaling: scale model servers based on traffic and latency.
- Fallbacks: use cached, heuristic, or smaller-model responses when needed.

## Important Metrics

- p50, p95, and p99 latency
- Throughput
- Error rate
- GPU or CPU utilization
- Model load time
- Prediction quality
- Timeout rate

## Deployment Strategies

- Shadow deployment: new model receives traffic copy but does not affect users.
- Canary deployment: small percentage of users receive the new model.
- A/B test: compare business or quality metrics.
- Blue-green deployment: switch traffic between old and new serving pools.

## Check Yourself

1. Why is p99 latency important for model serving?
2. When would you cache predictions?
3. What is a canary deployment?
4. How can a smaller model help production reliability?
5. What fallback can protect users during model server failure?
