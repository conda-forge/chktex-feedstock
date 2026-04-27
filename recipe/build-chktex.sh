#!/usr/bin/env bash
set -eux -o pipefail

export CFLAGS="${CFLAGS} -I${PREFIX}/include -I${PREFIX}/include/ncurses -I${PREFIX}/include/ncursesw"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L${PREFIX}/lib/ncurses -L${PREFIX}/lib/ncursesw"
export LIBS="-lncurses"

# https://github.com/conda-forge/chktex-feedstock/pull/8
## maybe double-packed?
ls configure || cd "${PKG_NAME}-${PKG_VERSION}"

cp COPYING "${SRC_DIR}/COPYING" || echo "COPYING already correct"

ln -s "${PREFIX}/bin/perl" "${PREFIX}/bin/perl5"

sed -iE "s/install: chktex ChkTeX.dvi/install: chktex/" Makefile.in

./configure --help

# TODO: probably want pcre, but keep segfaulting with 8.44
./configure \
    --disable-pcre \
    "--includedir=${PREFIX}/include" \
    "--libdir=${PREFIX}/lib" \
    "--prefix=${PREFIX}"

make all

make install

sed -i "s/perl5/perl/" "${PREFIX}/bin/deweb"

rm "${PREFIX}/bin/perl5"

make test
