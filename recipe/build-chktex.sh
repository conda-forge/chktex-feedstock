#!/usr/bin/env bash
set -eux -o pipefail


# https://github.com/conda-forge/chktex-feedstock/pull/8
## maybe double-packed?
ls configure || cd "${PKG_NAME}-${PKG_VERSION}"

cp COPYING "${SRC_DIR}/COPYING" || echo "COPYING already correct"

if [[ "${target_platform}" == "win-64" ]]; then
    ln -s "${PREFIX}/Library/usr/bin/perl.exe" "${PREFIX}/Library/usr/bin/perl5.exe"
else
    ln -s "${PREFIX}/bin/perl" "${PREFIX}/bin/perl5"
    export CFLAGS="${CFLAGS} -I${PREFIX}/include -I${PREFIX}/include/ncurses -I${PREFIX}/include/ncursesw"
    export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L${PREFIX}/lib/ncurses -L${PREFIX}/lib/ncursesw"
    export LIBS="${LIBS} -lncurses"
fi

sed -E --in-place "s/install: chktex ChkTeX.dvi/install: chktex/" Makefile.in

# TODO: probably want pcre, but keep segfaulting with 8.44
./configure \
    --disable-pcre \
    "--includedir=${PREFIX}/include" \
    "--libdir=${PREFIX}/lib" \
    "--prefix=${PREFIX}" \
    || ( \
       cat config.log \
       && exit 1 \
    )

make all

make install

sed --in-place "s/perl5/perl/" "${PREFIX}/bin/deweb"

if [[ "${target_platform}" == "win-64" ]]; then
    rm "${PREFIX}/Library/usr/bin/perl5.exe"
else
    rm "${PREFIX}/bin/perl5"
fi

make test
