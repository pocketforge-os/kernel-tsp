# Provenance

This repository contains the Linux 4.9.191 kernel source for the Allwinner
sun50iw10p1 SoC (used in the TrimUI Smart Pro handheld), extracted from the
CrealityTech Sonic Pad OS SDK.

## Upstream source

| Field              | Value |
|--------------------|-------|
| Repository         | https://github.com/CrealityTech/sonic_pad_os |
| Commit             | `7f37a7fbf4ad59907034715e3d967b9177de1cd4` |
| Extraction date    | 2026-06-15 |
| Extracted subtree  | `lichee/linux-4.9/` |
| Upstream license   | GPL-2.0 (repository-level) |
| Archival fork      | `pocketforge-os/sonic-pad-os-archive` (private; full SDK mirror for insurance) |

## What was kept

The entire `lichee/linux-4.9/` subtree (~875 MB, 66,280 files), placed at the
repository root. This is a standard Linux kernel tree with Allwinner BSP
additions (sunxi display, PowerVR GPU modules, XRadio WiFi, Cedar VPU, etc.).

Notable Allwinner-specific content:

- `modules/gpu/img-rgx/` -- PowerVR Rogue GPU kernel module source (DDK 1.11
  era; the PocketForge GPU KM rebuild uses DDK 1.19 from a separate upstream;
  see `pocketforge-os/gpu-km-tsp`).
- `modules/nand/` -- Allwinner NAND driver (includes a binary blob
  `common0/libnand`; not used on TrimUI Smart Pro which boots from SD/eMMC).
- `drivers/video/fbdev/sunxi/` -- Allwinner display engine 2.0 drivers.
- `drivers/net/wireless/xradio/` -- XRadio XR829 WiFi driver source.
- `rootfs.cpio.gz`, `rootfs_32bit.cpio.gz` -- upstream initramfs archives
  (not used by PocketForge; we build our own initrd).

## What was discarded

Everything outside `lichee/linux-4.9/` in the sonic_pad_os SDK:

- `lichee/brandy-2.0/` -- U-Boot 2018.05 + SPL source + embedded toolchain
  tarballs (~410 MB). PocketForge uses the vendor U-Boot as a SHA-pinned blob.
- `lichee/arisc/` -- ARISC coprocessor firmware/toolchain (~585 MB). Not
  modified by PocketForge.
- `prebuilt/` -- 7 prebuilt GCC cross-compiler toolchains (~1 GB). PocketForge
  uses its own pinned ARM 10.3-2021.07 toolchain.
- `package/` -- OpenWrt-style package recipes + bundled binaries (~1.7 GB).
  Includes Cortana/Skype SDK binaries irrelevant to PocketForge.
- `build/`, `config/`, `device/`, `docs/`, `scripts/`, `target/`, `toolchain/`,
  `tools/` -- OpenWrt/Tina build system infrastructure. PocketForge uses its
  own container-based build pipeline.

## Extraction method

```
git clone --depth=1 https://github.com/CrealityTech/sonic_pad_os.git
# Verified HEAD is 7f37a7fbf4ad59907034715e3d967b9177de1cd4
cp -a sonic_pad_os/lichee/linux-4.9/. kernel-tsp/
# kernel-tsp/ was a fresh git init with pocketforge-os/kernel-tsp as remote
```

## Kernel identity

```
VERSION = 4
PATCHLEVEL = 9
SUBLEVEL = 191
EXTRAVERSION =
NAME = Roaring Lionus
```

## License

This kernel source is licensed under GPL-2.0. See `COPYING` at the repository
root (the standard Linux kernel license file). Individual files may carry
additional per-file license headers as is standard in the Linux kernel tree.
