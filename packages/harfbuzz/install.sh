#! /bin/sh

set -e

# $1 : arch
# $2 : tarname
# $3 : prefix
# $4 : host
# $5 : taropt
# $6 : jobopt

dir_name=`tar t$5 $2 | head -1 | cut -f1 -d"/"`
cd $dir_name

EWPI_OS=`uname`
case ${EWPI_OS} in
    MSYS*|MINGW*)
        # for pkg-config
	prefix_unix=`cygpath -u $3`
    ;;
    *)
	prefix_unix=$3
    ;;
esac
export PATH=$prefix_unix/bin:$PATH
export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=$3/lib/pkgconfig
export PKG_CONFIG_SYSROOOT_DIR=$3
export CPPFLAGS=-I$3/include
export CFLAGS="-O2 -pipe -march=$1 -mtune=$1"
export CXXFLAGS="-O2 -pipe -march=$1 -mtune=$1"
export LDFLAGS="-s -L$3/lib"

./configure --prefix=$3 --host=$4 --disable-static --with-glib=no --disable-gtk-doc-html --disable-gtk-doc-pdf --with-cairo=no --with-fontconfig=no --with-freetype=yes --with-graphite2=yes --with-icu=no > ../config.log 2>&1

make -j $jobopt install > ../make.log 2>&1
