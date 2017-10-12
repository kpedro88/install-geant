#!/bin/bash

source init.sh

LIBS=(
libtbbmalloc.so \
libtbbmalloc.so.2 \
libtbbmalloc_proxy.so \
libtbb.so.2 \
libtbb.so \
libtbbmalloc_proxy.so.2 \
)

# link TBB
TBBDIR=${LOCAL}/tbb
mkdir ${TBBDIR}
mkdir ${TBBDIR}/include
ln -s ${LCG}/include/tbb ${TBBDIR}/include/tbb
ln -s ${LCG}/include/serial ${TBBDIR}/include/serial
mkdir ${TBBDIR}/lib
for LIB in ${LIBS[@]}; do
	ln -s ${LCG}/lib/${LIB} ${TBBDIR}/lib/${LIB}
done

