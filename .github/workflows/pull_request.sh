#!/bin/sh

set -e
set -v

test -z "$BUILD" && BUILD=build

rm -rf $BUILD

# ASAN build with clang
CC=clang meson $BUILD/asan -Db_sanitize=address -Db_lundef=false
ninja -C $BUILD/asan
meson test -C $BUILD/asan --suite style --print-errorlogs
meson test -C $BUILD/asan --no-suite style --print-errorlogs

# debug build with clang
CC=clang meson build/clang-debug -Dtran-pipe=true
ninja -C $BUILD/clang-debug
meson test -C $BUILD/clang-debug --no-suite style --print-errorlogs

# plain build with clang
CC=clang meson build/clang-plain -Dtran-pipe=true -Dbuildtype=plain
ninja -C $BUILD/clang-plain
meson test -C $BUILD/clang-plain --no-suite style --print-errorlogs

# debug build with gcc
CC=gcc meson build/gcc-debug -Dtran-pipe=true
ninja -C $BUILD/gcc-debug
meson test -C $BUILD/gcc-debug --no-suite style --print-errorlogs

# plain build with gcc
CC=gcc meson build/gcc-plain -Dtran-pipe=true
ninja -C $BUILD/gcc-plain
meson test -C $BUILD/gcc-plain --no-suite style --print-errorlogs

# valgrind tests
CC=gcc meson build/gcc-valgrind -Dtran-pipe=true -Dvalgrind=true
ninja -C $BUILD/gcc-valgrind
meson test -C $BUILD/gcc-valgrind --suite valgrind --print-errorlogs || :

DESTDIR=tmp.install meson install -C $BUILD/gcc-valgrind
