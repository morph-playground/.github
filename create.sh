#!/bin/bash
set -e

ORG="morph-playground"

repos=(
  "auth-service|Handles user authentication, session management (JWT/cookies), and OAuth integrations.|backend – TypeScript, Node.js, tRPC, Postgres"
  "permission-service|Handles user permissions.|backend – TypeScript, Node.js, tRPC, Postgres"
  "user-service|Manages user profiles, account settings, organizations, and team memberships.|backend – TypeScript, Node.js, tRPC, Postgres"
  "project-service|Central domain service managing projects, metadata, project states, and access control.|backend – TypeScript, Node.js, tRPC, Postgres"
  "task-service|Handles task creation, assignments, status updates, due dates, labels, etc.|backend – TypeScript, Node.js, tRPC, Postgres"
  "comment-service|Enables threaded comments on tasks and projects with notifications and edit history.|backend – TypeScript, Node.js, tRPC, Postgres"
  "file-service|Handles file uploads, storage, versioning, previews, and permissions.|backend – TypeScript, Node.js, AWS SDK, S3-compatible storage"
  "notification-service|Sends in-app, email, and real-time WebSocket notifications.|backend – TypeScript, Node.js, BullMQ, Postgres"
  "search-service|Provides indexed search for projects, tasks, users, and comments.|backend – TypeScript, Node.js, Elasticsearch"
  "activity-feed-service|Aggregates project activity into a stream (created tasks, comments, file uploads, etc).|backend – TypeScript, Node.js, Postgres"
  "audit-log-service|Stores immutable records of critical user and system actions for compliance and traceability.|backend – TypeScript, Node.js, Postgres"
  "billing-service|Manages subscriptions, invoices, and usage metering across user accounts.|backend – TypeScript, Node.js, Stripe SDK"
  "feature-flag-service|Controls feature rollouts per user, org, or environment for experiments and testing.|backend – TypeScript, Node.js, Postgres"
  "webapp-client|Main user-facing app for managing projects, tasks, files, and collaboration.|webapp – React, TypeScript, Vite, Tailwind"
  "admin-portal|Internal tool for support, content moderation, and system configuration.|webapp – React, TypeScript, Next.js, Tailwind"
  "api-gateway|Routes and proxies frontend requests to backend services securely.|backend – TypeScript, Node.js, Fastify or tRPC Gateway"
  "realtime-service|Pushes real-time updates for tasks, comments, presence indicators, and notifications.|backend – TypeScript, Node.js, WebSockets or Socket.IO"
  "config-service|Central config manager shared across services (may be embedded in deployment for simplicity).|backend – TypeScript, Node.js, dotenv/config loader"
  "logging-service|Centralized logging and tracing collector with support for distributed services.|infra – TypeScript, Node.js, Winston + OpenTelemetry"
  "metrics-service|Exposes operational metrics like request latency, error rates, and job queue health.|infra – TypeScript, Node.js, Prometheus + Grafana Exporter"
  "deployment-pipeline|CI/CD pipeline to lint, test, build, and deploy TypeScript services and frontends.|infra – GitHub Actions, Docker, Kubernetes Helm Charts"
)

create_repo() {
  local name="$1"
  echo "Creating repo: $name"

  http_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "https://api.github.com/orgs/$ORG/repos" \
    -H "Authorization: token $GITHUB_PAT" \
    -H "Accept: application/vnd.github+json" \
    -d "{\"name\":\"$name\",\"private\":false}")

  if [[ "$http_code" == "201" ]]; then
    echo "✅ Repository $name created."
  elif [[ "$http_code" == "422" ]]; then
    echo "⚠️  Repository $name already exists or validation error."
  else
    echo "❌ Failed to create $name. HTTP code: $http_code"
  fi
}

create_readme_commit() {
  local name="$1"
  local desc="$2"
  local stack="$3"

  local content="# $name

$desc

$stack
"

  local encoded=$(printf '%s' "$content" | base64 | tr -d '\n')

  echo "Adding README.md to $name"

  http_code=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "https://api.github.com/repos/$ORG/$name/contents/README.md" \
    -H "Authorization: token $GITHUB_PAT" \
    -H "Accept: application/vnd.github+json" \
    -d "{
      \"message\": \"Add README.md\",
      \"content\": \"$encoded\"
    }")

  if [[ "$http_code" == "201" ]]; then
    echo "✅ README.md added to $name."
  else
    echo "❌ Failed to add README.md to $name. HTTP code: $http_code"
  fi
}

# Loop (only first repo for debug)
IFS="|"
for line in "${repos[@]}"; do
  read -r name desc stack <<< "$line"

  create_repo "$name"
  create_readme_commit "$name" "$desc" "$stack"

done
