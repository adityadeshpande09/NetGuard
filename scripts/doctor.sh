#!/usr/bin/env bash
# make doctor: checks that every tool NetGuard needs is installed.
# Exits 1 if anything is missing or too old.
set -uo pipefail

if [ -t 1 ]; then
  GREEN=$'\e[32m'; RED=$'\e[31m'; YELLOW=$'\e[33m'; RESET=$'\e[0m'
else
  GREEN=""; RED=""; YELLOW=""; RESET=""
fi

failures=0

ok()   { printf "  %s✔%s %-12s %s\n" "$GREEN" "$RESET" "$1" "$2"; }
bad()  { printf "  %s✘%s %-12s %s\n" "$RED" "$RESET" "$1" "$2"; failures=$((failures + 1)); }
warn() { printf "  %s!%s %-12s %s\n" "$YELLOW" "$RESET" "$1" "$2"; }

# check <name> <binary> <version command>
check() {
  local name="$1" bin="$2" cmd="$3" out
  if ! command -v "$bin" >/dev/null 2>&1; then
    bad "$name" "missing"
    return 1
  fi
  out="$(bash -c "$cmd" 2>&1 | grep -v '^\s*$' | head -n 1)"
  ok "$name" "${out:-installed}"
}

echo "NetGuard doctor"
echo

check docker      docker      "docker --version"
check containerlab containerlab "containerlab version | grep -i version"
check java        java        "java -version"
check mvn         mvn         "mvn -v"
check python3     python3     "python3 --version"
check k3d         k3d         "k3d version"
check kubectl     kubectl     "kubectl version --client"
check helm        helm        "helm version --short"
check terraform   terraform   "terraform version"
check aws         aws         "aws --version"
check ansible     ansible     "ansible --version"
check trivy       trivy       "trivy --version"
check gh          gh          "gh --version"
check jq          jq          "jq --version"

echo
echo "Extra checks"

# Java 21+
if command -v java >/dev/null 2>&1; then
  java_major="$(java -version 2>&1 | head -n 1 | sed -E 's/.*version "([0-9]+).*/\1/')"
  if [[ "$java_major" =~ ^[0-9]+$ ]] && [ "$java_major" -ge 21 ]; then
    ok "java>=21" "found $java_major"
  else
    bad "java>=21" "found ${java_major:-unknown}"
  fi
fi

# Python 3.12+
if command -v python3 >/dev/null 2>&1; then
  if python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 12) else 1)' 2>/dev/null; then
    ok "python>=3.12" "$(python3 --version 2>&1)"
  else
    bad "python>=3.12" "$(python3 --version 2>&1 || echo unknown)"
  fi
fi

# Docker daemon reachable
if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    ok "docker-daemon" "reachable"
  else
    bad "docker-daemon" "not reachable (is Docker running?)"
  fi
fi

# .env present (only a warning: it is created by make secrets in Phase 3)
if [ -f .env ]; then
  ok ".env" "present"
else
  warn ".env" "not found (copy .env.example or run make secrets later)"
fi

echo
if [ "$failures" -eq 0 ]; then
  echo "${GREEN}All checks passed.${RESET}"
  exit 0
fi
echo "${RED}$failures check(s) failed.${RESET}"
exit 1
