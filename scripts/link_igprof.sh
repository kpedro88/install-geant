#!/bin/bash

source init.sh

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
mkdir ${IGPDIR}/bin
for BIN in ${BINS[@]}; do
	ln -s ${LCG}/bin/${BIN} ${IGPDIR}/bin/${LIB}
done

