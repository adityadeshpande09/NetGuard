# NetGuard - single front door for every workflow.
# Run `make` or `make help` to list targets.

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

COMPOSE := docker compose -f deploy/compose/docker-compose.yml --env-file .env

# Print a stub message and fail, so a stub is never mistaken for success.
define stub
@echo "$@: not implemented yet ($(1))"; exit 1
endef

.PHONY: help doctor lab-keys lab-up lab-down up up-obs down secrets test scan \
        k3d-up deploy-k3d k3d-down demo

help: ## List targets
	@grep -E '^[a-zA-Z0-9_-]+:.*## ' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*## "}; {printf "  %-12s %s\n", $$1, $$2}'

doctor: ## Check that every required tool is installed
	@bash scripts/doctor.sh

lab-keys: ## Generate the SSH key pair for the lab routers
	$(call stub,Phase 1)

lab-up: ## Deploy the Containerlab BGP fabric
	$(call stub,Phase 1)

lab-down: ## Destroy the Containerlab BGP fabric
	$(call stub,Phase 1)

up: ## Start the Compose stack (core + auth profiles)
	$(call stub,Phase 2)

up-obs: ## Start the Compose stack plus Prometheus and Grafana
	$(call stub,Phase 6)

down: ## Stop the Compose stack
	$(call stub,Phase 2)

secrets: ## Generate .env with random passwords
	$(call stub,Phase 3)

test: ## Run every test suite that exists so far
	@echo ">> bash syntax check"; \
	for f in scripts/*.sh .devcontainer/*.sh; do \
	  [ -f "$$f" ] || continue; \
	  bash -n "$$f"; \
	  echo "   ok  $$f"; \
	done; \
	for d in collector remediator; do \
	  if [ -f "$$d/pyproject.toml" ]; then \
	    echo ">> pytest $$d"; (cd "$$d" && python3 -m pytest -q); \
	  fi; \
	done; \
	if [ -f services/pom.xml ]; then \
	  echo ">> mvn verify"; (cd services && mvn -q -B verify); \
	fi; \
	if [ ! -f collector/pyproject.toml ] && [ ! -f remediator/pyproject.toml ] \
	   && [ ! -f services/pom.xml ]; then \
	  echo ">> no unit tests yet (collector, remediator, services not created)"; \
	fi

scan: ## Trivy filesystem scan, fails on CRITICAL
	$(call stub,Phase 3)

k3d-up: ## Create the single-node k3d cluster
	$(call stub,Phase 4)

deploy-k3d: ## Install the Helm chart into k3d
	$(call stub,Phase 4)

k3d-down: ## Delete the k3d cluster
	$(call stub,Phase 4)

demo: ## Run the end-to-end fault and remediation demo
	$(call stub,Phase 6)
