# Exercise: Design an Enterprise LLM Chatbot

Time limit: 45 minutes

## Problem

Design a chatbot that answers employee questions using private company documents. It must respect permissions, cite sources, avoid leaking sensitive data, and remain reliable when the model or retrieval layer fails.

## Requirements

- Users can ask natural-language questions.
- Answers should be grounded in company documents.
- The system must enforce document permissions.
- The answer should include source references.
- Admins can ingest, update, and delete documents.
- The system should monitor answer quality and safety.

## Design Prompts

1. What is the document ingestion pipeline?
2. Where are raw documents stored?
3. How are embeddings created and indexed?
4. How are permissions enforced?
5. How does the query flow work?
6. How do you prevent prompt injection from documents?
7. What should be logged?
8. What fallback should exist if retrieval fails?
9. How do you evaluate answer quality?

## Expected Architecture

Include:

- Document connector or upload service
- Object storage
- Text extraction and chunking
- Embedding pipeline
- Vector database
- Metadata and permission store
- Retrieval service
- Context builder
- LLM gateway
- Safety and policy layer
- Feedback and evaluation pipeline

## Stretch Questions

1. How would you support multiple tenants?
2. How would you delete all embeddings for a removed document?
3. How would you reduce latency and token cost?
4. How would you detect hallucinations?
5. How would you test permission boundaries?
