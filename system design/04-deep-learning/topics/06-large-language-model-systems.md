# Large Language Model Systems

LLM systems combine model serving, retrieval, orchestration, safety, memory, and observability. The model is only one part of the product.

## Common Patterns

- Direct prompting: send user input to the model.
- Retrieval-augmented generation: retrieve relevant documents before generation.
- Tool use: model calls APIs, databases, or code execution tools.
- Agent workflow: model plans and performs multiple steps.
- Fine-tuning: adapt a model to a specific task or style.

## RAG Architecture

```text
User Query -> Query Rewrite -> Embedding -> Vector Search -> Context Builder -> LLM -> Answer
                                  |              |
                                  v              v
                            Vector DB       Source Documents
```

## Serving Concerns

- Token latency: output speed matters because generation is sequential.
- Context length: more context costs more and can reduce focus.
- Caching: cache prompts, retrieval results, or final answers when safe.
- Safety: prevent sensitive data leakage, prompt injection, and unsafe outputs.
- Evaluation: test correctness, groundedness, refusal quality, and formatting.

## RAG Failure Cases

- Retriever returns irrelevant documents.
- Context is too large or poorly ordered.
- Model invents facts not supported by context.
- Permission filters are missing.
- Prompt injection inside retrieved documents changes model behavior.

## Check Yourself

1. What problem does RAG solve?
2. Why does permission filtering matter before retrieval results reach the model?
3. What is prompt injection?
4. Why is LLM evaluation harder than normal API testing?
5. When is fine-tuning better than retrieval?
