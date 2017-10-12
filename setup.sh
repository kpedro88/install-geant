#!/bin/bash

LINKS=(
python \
clhep \
xercesc \
)

INSTALLS=(
root \
geant4 \
hepmc \
pythia8 \
veccore \
vecgeom \
geantv \
)

CORES=1

join_by() { local IFS="$1"; shift; echo "$*"; }

usage() {
	echo "Options:"
	echo -e "-j [cores]          \tnumber of cores for make (default = $CORES)"
	echo -e "-L [pkg1,pkg2,...]  \tpackages to link from LCG (default = "$(join_by , "${LINKS[@]}")")"
	echo -e "-I [pkg1,pkg2,...]  \tpackages to install from source (default = "$(join_by , "${INSTALLS[@]}")")"
	echo -e "-h                  \tshow this message and exit"
	exit 1
}

# check arguments
while getopts "j:L:I:h" opt; do
	case "$opt" in
		j) CORES=$OPTARG
		;;
		L) IFS="," read -a LINKS <<< "$OPTARG"
		;;
		I) IFS="," read -a INSTALLS <<< "$OPTARG"
		;;
		h) usage
		;;
	esac
done

mkdir -p logs

# for each link/install, use a subshell and refresh the environment - build up in order

# link
for LINK in ${LINKS[@]}; do
	fname=scripts/link_${LINK}.sh
	if [ -e $fname ]; then
		echo "Linking ${LINK}"
		./$fname > logs/${LINK}.log 2>&1
	else
		echo "Can't link $LINK, exiting"
		exit 1
	fi
done

# install
for INSTALL in ${INSTALLS[@]}; do
	fname=scripts/install_${INSTALL}.sh
	if [ -e $fname ]; then
		echo "Installing ${INSTALL}"
		./$fname $CORES > logs/${INSTALL}.log 2>&1
	else
		echo "Can't install $INSTALL, exiting"
		exit 1
	fi
done
