# Contributing to kernel-tsp

This repository is a PocketForge-owned fork of the Linux 4.9.191 kernel for
the TrimUI Smart Pro (Allwinner sun50iw10p1). It is a stable BSP fork, not a
tracking fork -- we cherry-pick specific upstream changes rather than rebasing
onto upstream HEAD.

## Branch strategy

| Branch | Purpose |
|--------|---------|
| `main` | Our HEAD. All changes land via PR with required CI + review + signed commits. |
| `upstream` | Passive tracking branch. Periodically updated with upstream state for visibility. |
| `release/<tag>` | Signed release tags. Format: `tsp-4.9.191-YYYY.MM.DD-<short-sha>`. |

## Absorbing upstream patches

The upstream source is `CrealityTech/sonic_pad_os` (see `PROVENANCE.md`). The
upstream is largely dormant (12 commits total, last activity May 2023), so
absorb events are expected to be rare.

### Runbook

1. **Fetch upstream state:**
   ```
   git remote add sonic-pad-os https://github.com/CrealityTech/sonic_pad_os.git  # one-time
   git fetch sonic-pad-os main
   ```

2. **Inspect what changed in the kernel subtree:**
   ```
   git diff upstream..sonic-pad-os/main -- lichee/linux-4.9/
   ```
   Note: upstream sonic_pad_os has the kernel at `lichee/linux-4.9/`; our repo
   has it at root. Path translation is needed when cherry-picking.

3. **Triage:** Read the diff. Most upstream changes won't apply (we're a stable
   BSP fork; upstream churn is mostly Sonic-Pad-specific). Decide what to
   absorb.

4. **Cherry-pick to main via PR:** Create a feature branch, apply the relevant
   patches (adjusting paths from `lichee/linux-4.9/` to root), open a PR.
   CI must pass. Reviewer must approve.

5. **Update the upstream branch:** After absorbing (or deciding not to), update
   the `upstream` branch marker to record that we've triaged up to this point:
   ```
   git checkout upstream
   git merge --ff-only sonic-pad-os/main  # or reset to the fetched SHA
   git push origin upstream
   ```

### CVE awareness

Linux 4.9 is EOL upstream. When a known CVE affects a subsystem we expose to
network attack surface (rare on a kiosk device), the maintainer assesses
whether to backport the fix from mainline. Most CVEs that matter affect
subsystems we don't use.

The full drift-detection automation, CVE/OSV feed integration, and weekly
tracker workflow land in a future enterprise-CI effort (not this repo's scope
for Phase 2).

## Build

See the build recipe in `build-integration-reference.md` section 16.4 in the
main project docs. Quick summary:

```sh
export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-
export HOSTCFLAGS="-fcommon"
export KCFLAGS="-Wno-error"
make pocketforge_tsp_defconfig
make -j$(nproc) Image dtbs modules
```

Requires the PocketForge build container (`pocketforge/build:10.3-2021.07-bookworm`)
with `bc bison flex libssl-dev libelf-dev` installed.

## Commit conventions

- Sign all commits (`git commit -s`).
- Prefix commit messages with the subsystem affected when possible
  (e.g., `defconfig: enable CONFIG_NAMESPACES`, `dts: add pocketforge_tsp`).
- Keep the container-config flags (namespaces, cgroups, seccomp) in a separate,
  easily-revertible commit from the base defconfig.

## Code of conduct

Be kind and constructive. This is a small project; keep discussions technical.
