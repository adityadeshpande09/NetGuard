# NetGuard

Network assurance platform built as a portfolio project for SWE, security and
networking roles. A Python collector polls an FRR BGP lab (Containerlab) and
publishes to Kafka. Spring Boot services detect BGP faults and config drift.
Fixes go through four-eyes approval and are applied by an Ansible remediator.
Runs on Docker Compose, then Kubernetes (k3d). Terraform targets AWS EKS.

- Full spec, lab addressing, schemas, API and phase checklist: docs/PLAN.md
- Where we are and what passed: docs/progress.md
- Plain-English notes for interviews: docs/learning.md

Always read docs/PLAN.md and docs/progress.md before starting work.

## Environment

- GitHub Codespaces, 4 cores / 16 GB, dev container in .devcontainer/
- The stack must ALSO run in "lean mode" on an 8 GB laptop (see PLAN.md section 2)
- Linux x86_64 in the codespace; CI also builds linux/arm64 images

## Stack (do not swap without asking)

- Java 21 LTS, latest stable Spring Boot, Maven multi-module in services/
- Python 3.12 for collector/ and remediator/ (ruff, pytest)
- Apache Kafka in KRaft mode (official apache/kafka image)
- PostgreSQL with Flyway, one database, one schema and one DB user per service
- Keycloak for OAuth2/OIDC; every service is an OAuth2 resource server
- Containerlab + FRR (quay.io/frrouting/frr) for the lab; Ansible for remediation
- Helm on k3d; Terraform for AWS; GitHub Actions for CI; GHCR for images
- Prefer official images. Do not use Bitnami images.

## Hard rules

1. Everything stays free: no paid cloud resources, no paid APIs, no paid services.
2. Never commit secrets. Real values live in .env (gitignored) or Codespaces
   secrets. Keep .env.example current with placeholder values only.
3. Ask me before: git push, gh repo/settings changes, terraform plan/apply/destroy,
   any aws/az CLI command that creates or changes something, deleting files
   outside the repo, running anything with sudo that is not a package install.
4. One phase at a time. Start every phase in plan mode and wait for my approval.
5. Every feature ships with tests. Run `make test` before saying a step is done.
6. Memory budget: every container has a mem_limit. Spring Boot apps run with
   -XX:+UseSerialGC and a 300 MB limit, Kafka a 256 MB heap, Keycloak 512 MB.
   Never run the Compose stack and the k3d cluster at the same time.
7. Containers run as non-root. Validate all API input. Never return stack traces.
8. If something fails twice, stop and explain the root cause before retrying.
9. End of each phase: write the acceptance checks and their real results to
   docs/progress.md, add a short explanation of what was built and why to
   docs/learning.md, then tell me which checks I should run myself.
10. Small commits with conventional messages (feat:, fix:, test:, docs:, chore:).
    Tag phase-N only after I confirm the checks.

## Conventions

- Java packages: dev.netguard.<service>; Python packages: netguard_collector,
  netguard_remediator
- Kafka message key = device name; every event has "schemaVersion": 1
- Timestamps are UTC ISO-8601; all logs are JSON
- Config via environment variables only (12-factor)

## Make targets

doctor, lab-up, lab-down, up, down, test, scan, k3d-up, deploy-k3d, k3d-down, demo
