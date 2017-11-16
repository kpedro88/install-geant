#!/bin/bash

LINKS_ALL=(
python \
clhep \
xercesc \
boost \
tbb \
gdb \
)

INSTALLS_ALL=(
root \
geant4 \
hepmc \
pythia8 \
veccore \
vecgeom \
geantv \
toy-mt-framework \
)

CORES=1
LINKS=()
INSTALLS=()
DRYRUN=""
export DEBUGFLAG=""

case `uname` in
  Linux) ECHO="echo -e" ;;
  *) ECHO="echo" ;;
esac

join_by() { local IFS="$1"; shift; echo "$*"; }

usage() {
	$ECHO "Options:"
	$ECHO "-j [cores]          \tnumber of cores for make (default = $CORES)"
	$ECHO "-L [pkg1,pkg2,...]  \tpackages to link from LCG (allowed = "$(join_by , "${LINKS_ALL[@]}")"; or all)"
	$ECHO "-I [pkg1,pkg2,...]  \tpackages to install from source (allowed = "$(join_by , "${INSTALLS_ALL[@]}")"; or all)"
	$ECHO "-D                  \tdry-run: show option values and exit"
	$ECHO "-d                  \tenable debug flags for compilation (when available)"
	$ECHO "-f                  \tforce complete reinstallation (delete and recopy source directories)"
	$ECHO "-h                  \tshow this message and exit"
	exit 1
}

# check arguments
while getopts "j:L:I:Ddfh" opt; do
	case "$opt" in
		j) CORES=$OPTARG
		;;
		L) if [ "$OPTARG" = all ]; then LINKS=(${LINKS_ALL[@]}); else IFS="," read -a LINKS <<< "$OPTARG"; fi
		;;
		I) if [ "$OPTARG" = all ]; then INSTALLS=(${INSTALLS_ALL[@]}); else IFS="," read -a INSTALLS <<< "$OPTARG"; fi
		;;
		D) DRYRUN=true
		;;
		d) export DEBUGFLAG="-DCMAKE_BUILD_TYPE=Debug"
		;;
		f) export FORCERECOMP=true
		;;
		h) usage
		;;
	esac
done

mkdir -p logs

# for each link/install, use a subshell and refresh the environment - build up in order

if [ -n "$DRYRUN" ]; then
	$ECHO "CORES = $CORES"
	$ECHO "LINKS = "$(join_by , "${LINKS[@]}")
	$ECHO "INSTALLS = "$(join_by , "${INSTALLS[@]}")
	if [ -n "$DEBUGFLAG" ]; then
		$ECHO "DEBUGFLAG = $DEBUGFLAG"
	fi
	exit 0
fi

# link
for LINK in ${LINKS[@]}; do
	fname=scripts/link_${LINK}.sh
	if [ -e $fname ]; then
		$ECHO "Linking ${LINK}"
		./$fname > logs/${LINK}.log 2>&1
	else
		$ECHO "Can't link $LINK, exiting"
		exit 1
	fi
done

# install
for INSTALL in ${INSTALLS[@]}; do
	fname=scripts/install_${INSTALL}.sh
	if [ -e $fname ]; then
		$ECHO "Installing ${INSTALL}"
		./$fname $CORES > logs/${INSTALL}.log 2>&1
	else
		$ECHO "Can't install $INSTALL, exiting"
		exit 1
	fi
done
