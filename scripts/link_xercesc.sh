#!/bin/bash

source init.sh

LIBS=(
libxerces-c.so \
libxerces-c.la \
libxerces-c.a \
libxerces-c-3.1.so \
)

# link xercesc
XERCESCDIR=${LOCAL}/xercesc
mkdir ${XERCESCDIR}
mkdir ${XERCESCDIR}/include
ln -s ${LCG}/include/xercesc ${XERCESCDIR}/include/xercesc
mkdir ${XERCESCDIR}/lib
for LIB in ${LIBS[@]}; do
    ln -s ${LCG}/lib/${LIB} ${XERCESCDIR}/lib/${LIB}
done

