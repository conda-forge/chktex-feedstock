#!/usr/bin/env bash
set -eux

# TODO: probably want pcre, but keep segfaulting with 8.44
./configure \
    --prefix=$PREFIX \
    --disable-pcre

make all

make install

make test
