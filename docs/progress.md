# NetGuard progress

| Phase | Title | Status |
| --- | --- | --- |
| 0 | Scaffold | Built; Codespace checks pending |
| 1 | Lab and collector | Not started |
| 2 | Spring Boot services | Not started |
| 3 | Security and remediation | Not started |
| 4 | Kubernetes on k3d | Not started |
| 5 | CI/CD and Terraform | Not started |
| 6 | Observability, README, demo | Not started |
| S1–S5 | Stretch | Not started |

---

## Phase 0: scaffold (2026-11-07)

**Built:** the section 11 repo layout (empty dirs hold `.gitkeep`), a Makefile with every target (stubs exit 1 and name their phase), `scripts/doctor.sh`, `.gitignore`, `.gitattributes` (LF line endings), `.env.example`, a stub README, and this file plus learning.md.

**Where:** written on a Windows 11 machine, not the Codespace. That machine has git, Java 17 and Python, but no make, docker, mvn and so on.

### Acceptance checks

| # | Check | Where | Result |
| --- | --- | --- | --- |
| 1 | `bash -n scripts/doctor.sh` | Windows (Git Bash) | PASS |
| 2 | `bash scripts/doctor.sh` flags missing tools and exits 1 | Windows (Git Bash) | PASS: 13 failures (12 missing tools + Java 17 < 21), exit 1 |
| 3 | `make test` recipe run by hand (no make on Windows) | Windows (Git Bash) | PASS: both .sh files syntax-checked, "no unit tests yet", exit 0 |
| 4 | Test recipe fails on a script with a syntax error | Windows (Git Bash) | PASS: exit 2 |
| 5 | `make help` listing (grep/awk run by hand) | Windows (Git Bash) | PASS: 15 targets listed |
| 6 | First commit exists, no .env or zip tracked | Windows | See git log |
| 7 | `make doctor` all green | Codespace | PENDING: for you to run |
| 8 | `make test` exits 0 | Codespace | PENDING: for you to run |
| 9 | `make lab-up` prints its Phase 1 stub and exits non-zero | Codespace | PENDING: for you to run |

Not tagged `phase-0` yet. The tag goes on after checks 7–9 are confirmed.
