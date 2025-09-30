# TruMeID IDV — Starter Repo (MVP)

Enterprise-grade, Identity microservice for ID Document Validation + Liveness + Face Match.
- AWS CDK (TypeScript), API Gateway, Lambda (Node 20), Step Functions, DynamoDB, S3, EventBridge.
- Multi-tenant HMAC auth, idempotency, signed webhooks, audit, usage metering.
- Customer-managed storage via AssumeRole to tenant S3.

## Quick start
1) Install Node 20+ and AWS CDK v2.
2) `npm i` at the root, then `npm run bootstrap` (CDK bootstrap), then `npm run deploy:all`.
3) Configure Secrets (see `runbooks/onboarding.md`).

## Structure
See `/infra` (IaC), `/services` (Lambda), `/packages/sdk-js` (client SDK), `/specs` (OpenAPI).


## CI/CD
- GitHub Actions workflow at `.github/workflows/ci.yml` (OIDC assumes `AWS_DEPLOY_ROLE_ARN`).

## CLI
- Build: `npm run build --workspaces` then `npx trumeid tenant:create <tenantId> [name]` (or `node packages/cli/dist/index.js ...`).

## Postman
- Import `specs/postman_collection.json`. Set collection variables: `baseUrl`, `tenantId`, `keyId`, `secret`, `idemKey`.

## Workflow
- A Step Functions state machine is deployed. The `:confirm` API starts an execution and passes handler ARNs.
- `persistAndEmit` writes the verification record to DynamoDB (extend with Audit/Usage/EventBridge).

## Events & Webhooks
- `persistAndEmit` now puts `verification.updated` on EventBridge (source: `trumeid.verification`).
- Observability stack deploys a Webhook dispatcher Lambda triggered by this event with DLQ and retries.
- Webhook Lambda now auto-wired with Tenants table name via CDK to your Tenants table name (or update CDK to wire it automatically).
