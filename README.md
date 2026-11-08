# NetGuard

NetGuard is a network assurance platform. A Python collector polls a BGP lab built with Containerlab and FRR, and Spring Boot services detect routing faults and config drift. Fixes need four-eyes approval and are applied by an Ansible remediator.

Status: Phase 0 (scaffold). The full README arrives in Phase 6.

- Spec and phase checklist: [docs/PLAN.md](docs/PLAN.md)
- Progress and check results: [docs/progress.md](docs/progress.md)
- Project rules: [CLAUDE.md](CLAUDE.md)

```bash
make help     # list targets
make doctor   # check required tools
```
