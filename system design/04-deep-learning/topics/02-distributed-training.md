# Distributed Training Pipelines

Distributed training is used when one machine is not enough to train a model in reasonable time. The system splits work across multiple CPUs, GPUs, or accelerator nodes.

## Training Pipeline Stages

1. Data ingestion
2. Data validation
3. Feature transformation
4. Dataset creation
5. Training
6. Evaluation
7. Model packaging
8. Registry upload
9. Deployment approval

## Parallelism Types

- Data parallelism: each worker trains on a different data batch and synchronizes gradients.
- Model parallelism: different parts of the model live on different devices.
- Pipeline parallelism: model layers are split into stages.
- Tensor parallelism: large tensor operations are split across devices.

## Architecture

```text
Object Storage -> Data Loader -> Training Workers -> Checkpoints -> Evaluation -> Model Registry
                                      |
                                      v
                              Parameter/Gradient Sync
```

## Key Design Concerns

- GPU utilization: expensive accelerators should not wait for slow data loading.
- Checkpointing: long jobs must resume after failure.
- Reproducibility: data version, code version, config, and random seeds should be tracked.
- Scheduling: training jobs compete for shared compute.
- Cost control: spot instances can reduce cost but require strong checkpointing.

## Failure Handling

- Save checkpoints regularly.
- Retry failed workers.
- Track dataset and code versions.
- Validate data before expensive training starts.
- Stop training when loss becomes invalid or metrics collapse.

## Check Yourself

1. What is the difference between data parallelism and model parallelism?
2. Why is checkpointing critical?
3. What causes low GPU utilization?
4. Why should training data be versioned?
5. What metrics would you monitor during training?
