#!/bin/bash

source init.sh

LIBS=(
libigprof.so \
libunwind.so.7 \
)

BINS=(
igprof \
igprof-analyse \
igprof-analyse-old \
igprof-func \
igprof-navigator \
igprof-navigator-index.php \
igprof-navigator-summary \
igprof-populator \
igprof-segment \
igprof-symbol-sizes \
)

# link igprof
IGPDIR=${LOCAL}/igprof
mkdir ${IGPDIR}
mkdir ${IGPDIR}/lib
for LIB in ${LIBS[@]}; do
	ln -s ${LCG}/lib/${LIB} ${IGPDIR}/lib/${LIB}
done
mkdir ${IGPDIR}/bin
for BIN in ${BINS[@]}; do
	ln -s ${LCG}/bin/${BIN} ${IGPDIR}/bin/${BIN}
done
