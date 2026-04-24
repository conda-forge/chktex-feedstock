#!/usr/bin/env bash
set -eux -o pipefail

# https://github.com/conda-forge/chktex-feedstock/pull/8
## maybe double-packed?
ls configure || cd "${PKG_NAME}-${PKG_VERSION}"

ls configure

# TODO: probably want pcre, but keep segfaulting with 8.44
./configure \
    "--prefix=${PREFIX}" \
    --disable-pcre

make all

make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" && "${CROSSCOMPILING_EMULATOR:-}" == "" ]]; then
    make test
fi
