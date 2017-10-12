#!/bin/bash

source init.sh

# link xercesc
XERCESCDIR=${LOCAL}/xercesc
mkdir ${XERCESCDIR}
mkdir ${XERCESCDIR}/include
ln -s ${LCG}/include/xercesc ${XERCESCDIR}/include/xercesc
mkdir ${XERCESCDIR}/lib
for file in libxerces-c.so libxerces-c.la libxerces-c.a libxerces-c-3.1.so; do
	ln -s ${LCG}/lib/$file ${XERCESCDIR}/lib/$file
done

