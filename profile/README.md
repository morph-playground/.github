# .github

## 🧠 Core Services

- auth-service (backend – TypeScript, Node.js, tRPC, Postgres)
  Handles user authentication, session management (JWT/cookies), and OAuth integrations.
- user-service (backend – TypeScript, Node.js, tRPC, Postgres)
  Manages user profiles, account settings, organizations, and team memberships.
- project-service (backend – TypeScript, Node.js, tRPC, Postgres)
  Central domain service managing projects, metadata, project states, and access control.
- task-service (backend – TypeScript, Node.js, tRPC, Postgres)
  Handles task creation, assignments, status updates, due dates, labels, etc.
- comment-service (backend – TypeScript, Node.js, tRPC, Postgres)
  Enables threaded comments on tasks and projects with notifications and edit history.
- file-service (backend – TypeScript, Node.js, AWS SDK, S3-compatible storage)
  Handles file uploads, storage, versioning, previews, and permissions.

## 🧰 Platform Support Services

- notification-service (backend – TypeScript, Node.js, BullMQ, Postgres)
  Sends in-app, email, and real-time WebSocket notifications.
- search-service (backend – TypeScript, Node.js, Elasticsearch)
  Provides indexed search for projects, tasks, users, and comments.
- activity-feed-service (backend – TypeScript, Node.js, Postgres)
  Aggregates project activity into a stream (created tasks, comments, file uploads, etc).
- audit-log-service (backend – TypeScript, Node.js, Postgres)
  Stores immutable records of critical user and system actions for compliance and traceability.
- billing-service (backend – TypeScript, Node.js, Stripe SDK)
  Manages subscriptions, invoices, and usage metering across user accounts.
- feature-flag-service (backend – TypeScript, Node.js, Postgres)
  Controls feature rollouts per user, org, or environment for experiments and testing.

## 🌐 Frontends

- webapp-client (webapp – React, TypeScript, Vite, Tailwind)
  Main user-facing app for managing projects, tasks, files, and collaboration.
- admin-portal (webapp – React, TypeScript, Next.js, Tailwind)
  Internal tool for support, content moderation, and system configuration.

## ⚙️ Infrastructure Services
- api-gateway (backend – TypeScript, Node.js, Fastify or tRPC Gateway)
Routes and proxies frontend requests to backend services securely.
- realtime-service (backend – TypeScript, Node.js, WebSockets or Socket.IO)
Pushes real-time updates for tasks, comments, presence indicators, and notifications.
- config-service (backend – TypeScript, Node.js, dotenv/config loader)
Central config manager shared across services (may be embedded in deployment for simplicity).
- logging-service (infra – TypeScript, Node.js, Winston + OpenTelemetry)
Centralized logging and tracing collector with support for distributed services.
- metrics-service (infra – TypeScript, Node.js, Prometheus + Grafana Exporter)
Exposes operational metrics like request latency, error rates, and job queue health.
- deployment-pipeline (infra – GitHub Actions, Docker, Kubernetes Helm Charts)
CI/CD pipeline to lint, test, build, and deploy TypeScript services and frontends.
