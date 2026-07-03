# kernel-tsp

PocketForge-owned Linux 4.9.191 kernel fork for the TrimUI Smart Pro (A133 / sun50iw10). This is a signed source fork, NOT a blackbox — the pivot from vendor blob to owned source landed 2026-06-14 (Phase 2 substrate). Cross-repo doctrine lives in [`pocketforge-os/mission-control`](https://github.com/pocketforge-os/mission-control); this file is orientation only.

## Session startup + working norms

Run `bd prime` (auto-injected), `bd dolt pull`, register + background your pf-wall listener, `bd update <id> --claim`, and edit in a fresh `pf-wt create <bead-id> --repos kernel-tsp[,…]` worktree — never in `/home/matt/kernel-tsp` directly. Full checklist: [mission-control CLAUDE.md](https://github.com/pocketforge-os/mission-control/blob/master/CLAUDE.md); worktree/branch→PR→merge norm: [mission-control git-workflow rules](https://github.com/pocketforge-os/mission-control/blob/master/.claude/rules/git-workflow.md). Every change is a `<bead-id>` branch → PR → merge; no straight-to-default pushes.

## Shared Claude Code substrate

`.claude/settings.json` enables the shared `pf@pocketforge` plugin ([pocketforge-os/claude-plugins](https://github.com/pocketforge-os/claude-plugins)): skills (`/build-image`, `/close-bead`, `/file-bead`, `/flash`, `/kickoff`, `/plan-doc`, `/screen-check`, `/serial-review`), custom agents (`log-triage`, `researcher`, `screen-reviewer`), enforcement hooks (PreToolUse deny+redirect, Stop DoD gate, InstructionsLoaded audit).

## Repo-specific gotchas

- **Do NOT hand-build the kernel — use the `pf build` path** via [`/build-image`](https://github.com/pocketforge-os/claude-plugins/blob/main/plugins/pf/skills/build-image/SKILL.md) → `pocketforge-automation/scripts/build-owned-image.sh`. The image build resolves this repo through `platform.lock` and builds it inside the pinned `pocketforge/build:10.3-2021.07-bookworm` container. Native-toolchain output is non-reproducible and NOT release-valid ([mission-control provenance rules](https://github.com/pocketforge-os/mission-control/blob/master/.claude/rules/provenance.md)).
- **This repo is a release-signing repo** (currently registered in `gha_sign_repos`) — release workflows on `main` in the `sign` GitHub Environment can sign artifacts via the `pf-ci-sign` OIDC role. Do not add new signing paths without an [infra-060 §12.6 rotation runbook](https://github.com/pocketforge-os/mission-control/blob/master/.planning/infra/infra-060-secrets-management.md#12-implementation-record-2026-07-01-one-session) check.
- **Prefer owned-source fixes over blob patches.** When a bug looks like it lives in a closed vendor blob (`dc_sunxi.ko` etc.), first check whether a kernel-side fix in THIS repo (or `gpu-km-tsp`) covers it — the 2026-06-21 GPU bring-up rendered the cube on STOCK UM blobs via a one-line `dc_sunxi` format fix ([mission-control provenance rules](https://github.com/pocketforge-os/mission-control/blob/master/.claude/rules/provenance.md)).
