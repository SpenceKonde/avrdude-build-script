#!/bin/bash -ex
# Copyright (c) 2014-2016 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

git clone https://github.com/signal11/hidapi.git

cd hidapi
CONFARGS="--prefix=$PREFIX --disable-shared"
if [[ $CROSS_COMPILE != "" ]] ; then
  CONFARGS="$CONFARGS --host=$CROSS_COMPILE_HOST"
  # solve bug with --host not being effective on second level directory
  export CC=$CROSS_COMPILE_HOST-gcc
  export AR=$CROSS_COMPILE_HOST-ar
  export RANLIB=$CROSS_COMPILE_HOST-ranlib
fi
./bootstrap
CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ./configure $CONFARGS
make -j 1
make install
cd ..
