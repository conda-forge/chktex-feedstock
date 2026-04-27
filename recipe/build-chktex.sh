#!/usr/bin/env bash
set -eux -o pipefail

export CFLAGS="${CFLAGS} -I${PREFIX}/include -I${PREFIX}/include/ncurses -I${PREFIX}/include/ncursesw"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L${PREFIX}/lib/ncurses -L${PREFIX}/lib/ncursesw"

# https://github.com/conda-forge/chktex-feedstock/pull/8
## maybe double-packed?
ls configure || cd "${PKG_NAME}-${PKG_VERSION}"

./configure --help

# TODO: probably want pcre, but keep segfaulting with 8.44
./configure \
    "--prefix=${PREFIX}" \
    "--libdir=${PREFIX}/lib" \
    "--includedir=${PREFIX}/include" \
    --disable-pcre

make all

make install

make test
