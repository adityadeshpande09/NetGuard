# NetGuard learning notes

Plain-English notes on what was built and why, written for interview prep.

---

## Phase 0: scaffold

**What:** an empty but structured repo with a single front door (the Makefile), a tool checker (`make doctor`) and guardrails for secrets and line endings.

**Why a Makefile as the front door?** Every workflow (start the lab, run tests, deploy to k3d) gets one short, memorable command, and the same command works on your machine, in the Codespace and in CI. New contributors run `make help` instead of reading through scripts. Targets for later phases already exist as stubs that *fail* with "not implemented (Phase N)". A stub that silently succeeds would hide missing work.

**Why `make doctor`?** It checks the environment before anything else: 14 tools, plus Java 21+, Python 3.12+ and a running Docker daemon. It exits non-zero if anything is wrong. That turns "it doesn't work on my machine" into a clear list of what's missing. Version *minimums* matter as much as presence: this Windows machine has Java 17, and doctor catches it.

**Why `.gitignore` plus `.env.example`?** Real secrets live in `.env`, which is never committed. `.env.example` lists every variable with placeholder values, so the config's *shape* is documented and versioned while the *values* stay private. This is the 12-factor "config in the environment" idea.

**Why `.gitattributes`?** Windows editors save text with CRLF line endings, and bash in a Linux container fails on `\r` (`$'\r': command not found`). Forcing LF in the repo makes scripts behave the same everywhere.

**Why a `make test` that grows?** It runs whichever suites exist (bash syntax checks now, pytest and Maven later), so one command always means "everything that can be tested is tested", and it never needs rewiring.

### Likely interview questions

- *How do you keep secrets out of git?* `.env` is gitignored, only placeholders go in `.env.example`, and a pre-commit grep is in the phase checklist. CI adds a Trivy scan in Phase 3.
- *Why do stub targets fail instead of printing a TODO?* So automation can't mistake unfinished work for success. Exit codes are the contract.
- *What problem does `.gitattributes` solve?* Cross-platform line endings, and shell scripts breaking on CRLF.
- *Why check tool versions, not just presence?* Builds fail in confusing ways on old toolchains (e.g. Java 17 vs records and virtual threads in 21). Failing early with a clear message is cheaper.
