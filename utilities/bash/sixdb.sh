#!/bin/bash

function how_to_use() {
    cat <<EOF

   `basename $0` [options]
   to manage calls to sixdb

   This is mainly a bash wrapper for sixdb, and all terminal line arguments
      will be passed to sixdb BUT those preceeded by options.

   options (optional):
   -P      python path

   NB: in case you want yo use an option, please leave the actual arguments to
       sixdb to the end of the terminal-line command;

EOF
}
# get path to scripts (normalised)
if [ -z "${SCRIPTDIR}" ] ; then
    SCRIPTDIR=`dirname $0`
    SCRIPTDIR="`cd ${SCRIPTDIR};pwd`"
    export SCRIPTDIR=`dirname ${SCRIPTDIR}`
fi

# initialisation of local vars
pythonPath=""

# get options (heading ':' to disable the verbose error handling)
while getopts  ":hP:" opt ; do
    case $opt in
	h)
	    how_to_use
	    exit 1
	    ;;
	P)
	    # the user is requesting a specific path to python
	    pythonPath="${OPTARG}"
	    ;;
	:)
	    how_to_use
	    echo "Option -$OPTARG requires an argument."
	    exit 1
	    ;;
	\?)
	    how_to_use
	    echo "Invalid option: -$OPTARG"
	    exit 1
	    ;;
    esac
done
shift "$(($OPTIND - 1))"

# python path
source ${SCRIPTDIR}/bash/dot_profile
sixdeskDefinePythonPath ${pythonPath}

# actually call sixdb
python ${SCRIPTDIR}/externals/SixDeskDB/sixdb $*
