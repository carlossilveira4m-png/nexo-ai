# API Endpoints - Nexo AI

## Base URL
```
https://api.nexoai.app/api
```

## Authentication
All endpoints (except auth) require JWT token in header:
```
Authorization: Bearer <token>
```

## Payment Endpoints

### Stripe

#### Create Checkout Session
```
POST /payments/stripe/checkout
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "planId": "premium" | "pro"
}

Response:
{
  "url": "https://checkout.stripe.com/..."
}
```

#### Create PIX Payment
```
POST /payments/pix
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "planId": "premium" | "pro"
}

Response:
{
  "clientSecret": "pi_xxx#ps_xxx",
  "amount": 1990
}
```

### Google Play Billing

#### Verify Purchase
```
POST /payments/google-play/verify
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "packageName": "com.nexoai.app",
  "productId": "nexo_ai_premium",
  "token": "purchase-token-from-google"
}

Response:
{
  "success": true,
  "purchaseDetails": {...}
}
```

### Apple In-App Purchase

#### Verify Receipt
```
POST /payments/apple/verify
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "receipt": "base64-encoded-receipt"
}

Response:
{
  "success": true,
  "receiptData": {...},
  "isActive": true
}
```

### Subscription

#### Get User Subscription
```
GET /payments/subscription
Authorization: Bearer <token>

Response:
{
  "id": "sub_xxx",
  "plan": "premium" | "pro",
  "status": "active" | "cancelled" | "expired",
  "currentPeriodEnd": "2024-06-09T18:30:36Z"
}
```

#### Cancel Subscription
```
POST /payments/cancel-subscription
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "subscriptionId": "sub_xxx"
}

Response:
{
  "success": true
}
```

### Webhooks

#### Stripe Webhook
```
POST /payments/webhook
Content-Type: application/json
Stripe-Signature: <signature>

Webhook Events:
- payment_intent.succeeded
- payment_intent.payment_failed
- customer.subscription.updated
- customer.subscription.deleted
- invoice.payment_succeeded
- invoice.payment_failed
```

## Chat Endpoints

#### Send Message
```
POST /chat/send
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "content": "Quais minhas prioridades hoje?"
}

Response:
{
  "id": "msg_xxx",
  "content": "Aqui estão suas prioridades...",
  "role": "assistant",
  "createdAt": "2024-05-09T18:30:36Z"
}
```

#### Get Chat History
```
GET /chat/history?limit=50&offset=0
Authorization: Bearer <token>

Response:
{
  "messages": [...],
  "total": 150
}
```

## Memory Endpoints

#### Save Memory
```
POST /memory/save
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "type": "link" | "text" | "idea" | "note" | "file",
  "title": "Memory Title",
  "content": "Memory content",
  "url": "https://...",
  "tags": ["tag1", "tag2"]
}

Response:
{
  "id": "mem_xxx",
  "type": "link",
  "title": "Memory Title",
  "createdAt": "2024-05-09T18:30:36Z"
}
```

#### Search Memories
```
GET /memory/search?q=flutter&limit=10
Authorization: Bearer <token>

Response:
{
  "memories": [...],
  "total": 5
}
```

#### Get Memories
```
GET /memory?type=link&limit=20&offset=0
Authorization: Bearer <token>

Response:
{
  "memories": [...],
  "total": 100
}
```

## Task Endpoints

#### Create Task
```
POST /tasks
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "title": "Task Title",
  "description": "Task description",
  "dueDate": "2024-05-15T15:00:00Z",
  "priority": "alta" | "média" | "baixa",
  "category": "work" | "personal",
  "tags": ["tag1", "tag2"]
}

Response:
{
  "id": "task_xxx",
  "title": "Task Title",
  "status": "pending",
  "createdAt": "2024-05-09T18:30:36Z"
}
```

#### Get Tasks
```
GET /tasks?status=pending&priority=alta&limit=20
Authorization: Bearer <token>

Response:
{
  "tasks": [...],
  "total": 50
}
```

#### Update Task
```
PUT /tasks/:id
Content-Type: application/json
Authorization: Bearer <token>

Body:
{
  "status": "completed",
  "title": "Updated Title"
}

Response:
{
  "id": "task_xxx",
  "title": "Updated Title",
  "status": "completed"
}
```

## Auth Endpoints

#### Register
```
POST /auth/register
Content-Type: application/json

Body:
{
  "email": "user@example.com",
  "password": "secure-password",
  "fullName": "User Name"
}

Response:
{
  "token": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": {...}
}
```

#### Login
```
POST /auth/login
Content-Type: application/json

Body:
{
  "email": "user@example.com",
  "password": "secure-password"
}

Response:
{
  "token": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": {...}
}
```

#### Refresh Token
```
POST /auth/refresh
Content-Type: application/json

Body:
{
  "refreshToken": "eyJhbGc..."
}

Response:
{
  "token": "eyJhbGc..."
}
```

## Error Responses

All errors follow this format:
```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "statusCode": 400
}
```

### Common Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict
- `422` - Unprocessable Entity
- `429` - Too Many Requests
- `500` - Internal Server Error
