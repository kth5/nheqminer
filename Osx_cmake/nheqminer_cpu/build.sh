#!/bin/bash
OBJCONV=$(pwd)/fasm-osx/objconv
STATIC_LIBS=$(pwd)/deps

# clean up
rm -rf CMakeFiles/ CMakeCache.txt cmake_install.cmake Makefile

export CC=gcc-6 
export CXX=g++-6
export CFLAGS="-Ofast -fPIC"
export CXXFLAGS="-Ofast -std=c++14"

# unrealiably install dependency
#(
#cd deps/boost_1_55_0/;
#./boostrap.sh --with-toolset=gcc
#./b2 clean 
#./b2 cflagsvariant=release toolset=gcc runtime-link=static threading=multi debug-symbols=off cflags="${CFLAGS}" cxxflags="${CXXFLAGS}" --layout=system --prefix=${STATIC_LIBS} install
#)

# assmble xenocat's asms and convert to mach objects for OSX
install -m755 fasm-osx/fasm ../../cpu_xenoncat/Linux/asm/fasm
(cd ../../cpu_xenoncat/Linux/asm/; sh ./assemble.sh; 
${OBJCONV} -fmacho32 -nu equihash_avx1.o equihash_avx1m.o && mv equihash_avx1m.o equihash_avx1.o
${OBJCONV} -fmacho32 -nu equihash_avx2.o equihash_avx2m.o && mv equihash_avx2m.o equihash_avx2.o
) 

# configure nheqminer
cmake . -DBOOST_ROOT=${STATIC_LIBS}/boost
