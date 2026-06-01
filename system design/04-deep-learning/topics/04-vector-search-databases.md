# Vector Search and Vector Databases

Vector search finds similar items by comparing embeddings. An embedding is a numeric representation of text, images, audio, video, users, or products.

## Use Cases

- Semantic search
- Recommendation retrieval
- Duplicate detection
- Image search
- Retrieval-augmented generation
- Clustering and personalization

## Core Flow

```text
Document -> Embedding Model -> Vector Index
Query    -> Embedding Model -> Nearest Neighbor Search -> Top Results
```

## Vector Index Concepts

- Exact search: compares the query with every vector. Accurate but slow at scale.
- Approximate nearest neighbor search: faster search with small accuracy trade-off.
- Metadata filtering: restrict results by tenant, language, category, permissions, or time.
- Hybrid search: combines keyword search and vector search.
- Re-ranking: uses a stronger model to reorder top candidates.

## Design Concerns

- Embedding versioning: changing the embedding model may require re-indexing.
- Freshness: new documents should become searchable quickly.
- Permissions: search must not leak private data.
- Recall vs latency: faster indexes may miss some relevant results.
- Storage cost: large vectors require significant memory or disk.

## Check Yourself

1. What does an embedding represent?
2. Why is approximate search useful?
3. Why is metadata filtering important?
4. What happens when you change the embedding model?
5. Why might hybrid search outperform pure vector search?
