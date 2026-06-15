# syntax=docker/dockerfile:1.6
#
# kernel-tsp CI build container
# ==========================================================================
# Minimal container for building the PocketForge kernel-tsp fork.
# Contains only the ARM A-Profile Toolchain 10.3-2021.07 (gcc 10.3.1,
# glibc 2.33) and kernel build dependencies (bc, bison, flex, etc.).
#
# This is intentionally leaner than the full pocketforge/build container
# in the image repo — no mmdebstrap, no rootfs tooling, no SDL3 cross-deps.
# Kernel builds only.
#
# Build:
#   docker build -t pocketforge/kernel-build:10.3-2021.07 .github/
#
# Run:
#   docker run --rm \
#     --user "$(id -u):$(id -g)" \
#     -v "$PWD:/work/src:ro" \
#     -v "$PWD/out:/work/out" \
#     pocketforge/kernel-build:10.3-2021.07 \
#     bash -c "<build commands>"
#
# ==========================================================================

# =========================================================================
# Stage 1 — toolchain-fetch
# Fetch + verify + unpack the ARM A-Profile Toolchain 10.3-2021.07.
# =========================================================================
FROM debian:bookworm-slim AS toolchain-fetch

ARG TOOLCHAIN_VERSION=10.3-2021.07
ARG TOOLCHAIN_TRIPLET=aarch64-none-linux-gnu
ARG TOOLCHAIN_TARBALL=gcc-arm-${TOOLCHAIN_VERSION}-x86_64-${TOOLCHAIN_TRIPLET}.tar.xz
ARG TOOLCHAIN_URL=https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/${TOOLCHAIN_VERSION}/binrel/${TOOLCHAIN_TARBALL}

# Dual-pin: SHA-256 (computed locally 2026-06-10) + MD5 (Arm-published).
ARG TOOLCHAIN_SHA256=1e33d53dea59c8de823bbdfe0798280bdcd138636c7060da9d77a97ded095a84
ARG TOOLCHAIN_MD5=07bbe2b5277b75ba36a924e9136366a4

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/toolchain

RUN set -eux; \
    curl --fail --silent --show-error --location \
         --output "${TOOLCHAIN_TARBALL}" \
         "${TOOLCHAIN_URL}"; \
    echo "${TOOLCHAIN_SHA256}  ${TOOLCHAIN_TARBALL}" | sha256sum -c -; \
    echo "${TOOLCHAIN_MD5}  ${TOOLCHAIN_TARBALL}" | md5sum -c -

RUN set -eux; \
    mkdir -p /opt; \
    tar -xJf "${TOOLCHAIN_TARBALL}" -C /opt; \
    mv "/opt/gcc-arm-${TOOLCHAIN_VERSION}-x86_64-${TOOLCHAIN_TRIPLET}" \
       "/opt/arm-${TOOLCHAIN_VERSION}"

# =========================================================================
# Stage 2 — final
# Kernel build environment with the cross-toolchain + build deps.
# =========================================================================
FROM debian:bookworm-slim AS final

# Copy the pre-verified toolchain from stage 1.
COPY --from=toolchain-fetch /opt/arm-10.3-2021.07 /opt/arm-10.3-2021.07

# Kernel build dependencies.
# gcc = host compiler for build-time tools (fixdep, dtc, genksyms).
# bc bison flex = kconfig + kernel build requirements.
# libssl-dev libelf-dev = kernel crypto + BTF/module signing.
# cpio gzip = initrd assembly (if needed downstream).
# minisign = release signing (PocketForge release key, Ed25519).
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bc \
        bison \
        build-essential \
        cpio \
        flex \
        gcc \
        git \
        gzip \
        libelf-dev \
        libssl-dev \
        make \
        minisign \
        python3 \
        tar \
        xz-utils \
 && rm -rf /var/lib/apt/lists/*

# Add the cross-compiler to PATH.
ENV PATH="/opt/arm-10.3-2021.07/bin:${PATH}"

# Smoke-test: the cross-compiler resolves and targets aarch64.
RUN set -eux; \
    aarch64-none-linux-gnu-gcc --version; \
    aarch64-none-linux-gnu-gcc -dumpmachine | grep -q aarch64

WORKDIR /work
