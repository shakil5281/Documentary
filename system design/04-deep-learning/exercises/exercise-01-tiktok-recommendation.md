# Exercise: Design a TikTok-Style Feed Recommendation System

Time limit: 45 minutes

## Problem

Design a personalized short-video feed. The system should recommend videos, learn from user behavior, support new users and new videos, and serve results with low latency.

## Requirements

- Return a ranked feed for each user.
- Use watch time, likes, skips, shares, follows, reports, and comments as feedback.
- Support fresh videos and trending content.
- Handle cold-start users and cold-start videos.
- Prevent unsafe or blocked content from appearing.
- Log impressions and interactions for retraining.

## Design Prompts

1. What APIs are needed?
2. What events should be logged?
3. How do you generate candidates?
4. How do you rank candidates?
5. How do you add exploration without hurting user experience?
6. How do you handle moderation?
7. What features are needed online?
8. What should be cached?
9. How do you monitor quality?

## Expected Architecture

Include:

- Event tracking pipeline
- Data lake or warehouse
- Offline training
- Feature store
- Candidate generation service
- Ranking service
- Re-ranking and policy layer
- Feed API
- Experimentation platform
- Monitoring and retraining loop

## Stretch Questions

1. How would the design change for 100 million daily users?
2. How would you support multiple countries and languages?
3. How would you detect recommendation loops or low-diversity feeds?
4. How would you rollback a bad ranking model?
