#!/bin/bash
# SessionStart hook for Claude Code on the web.
#
# This repo is a Next.js site (pnpm-managed, see package.json's
# "packageManager" field) with a lint script ("next lint") but no test
# suite. Install JS dependencies so `pnpm lint` and `pnpm build` work in a
# fresh remote session.
set -euo pipefail

# Only do this in Claude Code on the web (remote) sessions.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# Use corepack to get the exact pnpm version pinned in package.json's
# "packageManager" field, then install dependencies. `pnpm install`
# (not `--frozen-lockfile`/`ci`) so the container cache can be reused
# and updated incrementally across sessions.
corepack enable >/dev/null 2>&1 || true
corepack prepare --activate >/dev/null 2>&1 || true

pnpm install
