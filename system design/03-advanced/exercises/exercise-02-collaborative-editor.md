# Exercise: Design a Collaborative Editor

Time limit: 45 minutes

## Problem

Design a collaborative document editor similar to Google Docs. Multiple users should edit the same document at the same time and see changes with low latency.

## Requirements

- Users can create, read, update, and share documents.
- Multiple users can edit one document concurrently.
- Users should see other users' cursors and presence.
- Document changes should be persisted.
- The system should support undo/redo.
- The system should recover from client disconnects.
- Permissions must be enforced.

## Non-functional Requirements

- Low latency for collaboration.
- Strong durability for document changes.
- High availability for reads and editing sessions.
- Correct conflict handling.
- Secure sharing and access control.

## APIs and Events

```text
POST /documents
GET /documents/{id}
POST /documents/{id}/share
WebSocket /documents/{id}/session

client_event: operation_submitted
server_event: operation_accepted
server_event: remote_operation
server_event: presence_updated
```

## Core Components

- API gateway
- Document service
- Collaboration session service
- WebSocket gateway
- Operation log
- Snapshot store
- Presence service
- Permission service
- Conflict resolution engine
- Background compaction worker
- Object storage or document blob store

## Conflict Resolution Options

- Operational Transformation
- Conflict-free Replicated Data Types

Operational Transformation is common for text editing with central coordination. CRDTs are useful when clients may edit offline and later merge.

## Suggested Data Model

```text
documents(id, owner_id, title, current_version, created_at, updated_at)
document_snapshots(id, document_id, version, content_ref, created_at)
operations(id, document_id, base_version, operation, author_id, created_at)
document_permissions(document_id, user_id, role)
presence(document_id, user_id, cursor_position, last_seen)
```

## Design Focus Areas

1. How do clients connect to an editing session?
2. How are operations ordered?
3. How are conflicts resolved?
4. How are document snapshots created?
5. How does a reconnecting client catch up?
6. How are permissions enforced before joining a session?
7. How is presence handled without polluting durable document history?

## Failure Scenarios

- Client disconnects after sending an operation.
- Collaboration server crashes.
- Two users edit the same position.
- Snapshot creation fails.
- User permission is revoked while editing.
- Hot document receives many concurrent editors.

## Expected Answer

Your answer should include:

- Requirements and scale assumptions
- WebSocket architecture
- Operation ordering strategy
- OT or CRDT choice
- Persistence model
- Snapshot and compaction plan
- Presence design
- Permission enforcement
- Monitoring and failure recovery

## Stretch Questions

1. How would you support offline edits?
2. How would you support comments and suggestions?
3. How would you handle a document with 10,000 viewers?
4. How would you support document version history?
5. How would you replicate editing sessions across regions?
