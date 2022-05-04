#!/bin/sh

set -e

test -z "$BUILD" && BUILD=build

rm -rf $BUILD

# ASAN build with clang
CC=clang meson $BUILD/asan -Db_sanitize=address -Db_lundef=true
meson compile -C $BUILD/asan
meson test -C $BUILD/asan --suite style
meson test -C $BUILD/asan --no-suite style

# debug build with clang
CC=clang meson build/clang-debug -Dtran-pipe=true
meson compile -C $BUILD/clang-debug
meson test -C $BUILD/clang-debug --no-suite style

# plain build with clang
CC=clang meson build/clang-plain -Dtran-pipe=true -Dbuildtype=plain
meson compile -C $BUILD/clang-plain
meson test -C $BUILD/clang-plain --no-suite style

# debug build with gcc
CC=gcc meson build/gcc-debug -Dtran-pipe=true
meson compile -C $BUILD/gcc-debug
meson test -C $BUILD/gcc-debug --no-suite style

# plain build with gcc
CC=gcc meson build/gcc-plain -Dtran-pipe=true -Dvalgrind=true
meson compile -C $BUILD/gcc-plain
meson test -C $BUILD/gcc-plain --no-suite style
DESTDIR=tmp.install meson install -C $BUILD/gcc-plain

# valgrind tests
CC=gcc meson build/gcc-valgrind -Dtran-pipe=true -Dvalgrind=true
meson compile -C $BUILD/gcc-valgrind
meson test -C $BUILD/gcc-valgrind --suite valgrind || :

DESTDIR=tmp.install meson install -C $BUILD/gcc-valgrind
