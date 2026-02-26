# Design: Webhook Delivery System

## Overview

Build a webhook delivery system that allows users to register endpoints and receive event notifications via HTTP POST. The system should be reliable, fast, and handle high throughput.

## Requirements

1. **Endpoint Registration** — Users can register webhook URLs with an associated event type. Store endpoint URL, event type, and a secret key for signature verification.

2. **Event Delivery** — When an event occurs, deliver the payload to all registered endpoints for that event type via HTTP POST. Include a signature header using HMAC-SHA256.

3. **Retry Logic** — Retry failed deliveries with exponential backoff. Failures should be retried automatically.

4. **Delivery Logging** — Log every delivery attempt with timestamp, status code, and response time. Queryable via API.

5. **Rate Limiting** — Limit deliveries to 100 requests per second per endpoint to avoid overwhelming receivers.

## Architecture

### Queue

Use Redis as the message queue. Events are published to Redis and workers consume from the queue to deliver webhooks.

### Workers

A pool of worker processes pulls from the Redis queue. Each worker handles one delivery at a time. Workers are stateless.

### Storage

PostgreSQL for endpoint registration, delivery logs, and event metadata.

### API

REST API for managing endpoints (CRUD) and querying delivery logs.

## Non-Functional Requirements

- Handle high throughput
- 99.9% delivery success rate for healthy endpoints
- Delivery latency under 5 seconds for the first attempt

## Security

- HMAC-SHA256 signature on every payload
- Endpoints validated on registration (must return 200 to a test ping)
- Secret keys encrypted at rest
