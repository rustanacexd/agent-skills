# Implementation Plan: Webhook Delivery System

Based on: flawed-design.md

## Task 1: Database Schema and Models

Set up PostgreSQL schema for webhook endpoints and delivery logs.

Tables:
- `endpoints`: id, url, event_type, secret_key, created_at
- `delivery_logs`: id, endpoint_id, event_id, status_code, response_time_ms, created_at

Create TypeORM entities and migrations.

## Task 2: REST API for Endpoint Management

Build CRUD endpoints:
- POST /webhooks — register endpoint
- GET /webhooks — list endpoints
- GET /webhooks/:id — get endpoint details
- PUT /webhooks/:id — update endpoint
- DELETE /webhooks/:id — delete endpoint

Include input validation and error handling.

## Task 3: Webhook Delivery Engine

Implement the core delivery logic:
- Accept event payload and target endpoint
- POST payload to endpoint URL
- Compute HMAC-SHA256 signature and include as header
- Handle timeouts (10 second timeout per delivery)
- Parse response and log result
- If delivery fails, add to retry queue with exponential backoff
- Rate limit outbound requests to 100/sec per endpoint

## Task 4: Redis Queue Integration

Set up Redis pub/sub for event distribution. When an event is published:
- Fan out to all registered endpoints for that event type
- Add each delivery job to the worker queue
- Workers consume and execute deliveries using Task 3's engine

## Task 5: Delivery Log Query API

- GET /webhooks/:id/deliveries — paginated delivery history
- GET /webhooks/:id/deliveries/stats — success rate, avg response time
- Filter by date range, status code

## Task 6: Webhook Analytics Dashboard

Build a React dashboard showing:
- Delivery success/failure rates over time
- Endpoint health status
- Real-time delivery feed
- Alert configuration for failing endpoints

## Task 7: Add Monitoring

Add monitoring to the system.

## Task 8: Worker Pool Management

Implement worker process management:
- Spawn N workers on startup
- Health check workers
- Restart failed workers
- Graceful shutdown on SIGTERM
