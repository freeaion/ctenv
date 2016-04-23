#!/bin/bash
# -------------------------------------------------------------------------
# self-extract script automatically generated ctenv
#
# depending on user's preference, this script can
# a) create a directory with files tar-zipped in this script
# b) generate a zip file
#
# Copyright 2016 by Yonghyun Hwang <freeaion@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# Some rights reserved.
# -------------------------------------------------------------------------

CTENV_GCONST_MOBILE_SH="SH"
CTENV_GCONST_MOBILE_SH_NAME="`basename $0`"

CTENV_GVAL_MOBILE_SH_NAME=""

function ctenv_prt_success
{
    echo -n "CTENV[SUCCESS|`date +'%m/%d %H:%M'`]::$1: "
    shift
    echo "$@"
    return 0
}

function ctenv_prt_error
{
    echo -n "CTENV[ERROR|`date +'%m/%d %H:%M'`]::$1: "
    shift
    echo "$@"
    return 0
}

function ctenv_prt_info
{
    echo -n "CTENV[INFO|`date +'%m/%d %H:%M'`]::$1: "
    shift
    echo "$@"
    return 0
}

function ctenv_confirm_usr_decision
{
    local arg=$1
    local decision=""

    while [ 1 ]
      do
        echo -n ${arg} "[Y/N]? "
        read -n 1 decision
        echo ""

        decision=`echo $decision |  tr "[:lower:]" "[:upper:]"`

        if [ -z $decision ]; then
    	    continue
        elif [ $decision == "Y" ]; then
    	    return 0
        elif [ $decision == "N" ]; then
    	    return 1
        fi
    done

    return 0
}

# solaris doesn't have 'whoami'
function ctenv_get_whoami
{
    local ostype=`uname -s`

    if [ ${ostype} = 'Linux' ]; then
        whoami
    else
        local who=(`who am i`)
        echo ${who[0]}
    fi

    return 0
}

function ctenv_readlink
{
    local opt=${1:-} # expect -f
    local path=${2:-}

    if [ -z ${path} ]; then
        echo ""
        return 1
    fi

    # solaris doesn't have readlink. :'(
    if [ -d ${path} ]; then
        pushd ${path} &> /dev/null
        echo $PWD
    elif [ -f ${path} ]; then
        pushd $(dirname ${path}) &> /dev/null
        echo $PWD/$(basename ${path})
    else
        echo ""
        return 1
    fi
    popd &> /dev/null

    return 0
}

function ctenv_get_tmp_file
{
    local tmpFilename=""

    # handle a prefix
    if [ -z ${1:-} ]; then
        tmpFilename=$(mktemp /tmp/`ctenv_get_whoami`_CTENV_TMP.XXXXX)
    else
        tmpFilename=$(mktemp /tmp/${1}_`ctenv_get_whoami`_CTENV_TMP.XXXXX)
    fi

    # handle a suffix
    if [ ! -z ${2:-} ]; then
       mv ${tmpFilename} ${tmpFilename}.${2}
       tmpFilename=${tmpFilename}.${2}
    fi

    if [ $? -eq 0 ]; then
	    echo ${tmpFilename}
    else
	    echo ""
    fi

    return 0
}

function ctenv_get_tmp_dir
{
    local tmpFilename=""

    # handle a prefix
    if [ -z ${1:-} ]; then
        tmpFilename=$(mktemp -d /tmp/`ctenv_get_whoami`_CTENV_TMP.XXXXX)
    else
        tmpFilename=$(mktemp -d /tmp/${1}_`ctenv_get_whoami`_CTENV_TMP.XXXXX)
    fi

    # handle a suffix
    if [ ! -z ${2:-} ]; then
       mv ${tmpFilename} ${tmpFilename}.${2}
       tmpFilename=${tmpFilename}.${2}
    fi

    if [ $? -eq 0 ]; then
	    echo ${tmpFilename}
    else
	    echo ""
    fi

    return 0
}

function ctenv_add_tmp_file_list
{
    local filename=${1:-}
    if [ -z ${filename} ]; then
	    return 1
    else
       CTENV_GARRAY_TMP_FILES[${#CTENV_GARRAY_TMP_FILES[@]}]=${filename}
	    return 0
    fi
}

function ctenv_remove_tmp_files
{
    local -i i=0
    for (( i=0; i<${#CTENV_GARRAY_TMP_FILES[@]}; i++)); do
       rm -fr ${CTENV_GARRAY_TMP_FILES[i]} >& /dev/null
    done
    
    CTENV_GARRAY_TMP_FILES=()

    return 0
}

# this function is called when ctenv exits
function ctenv_exit
{
    # remove tmp files if any
    ctenv_remove_tmp_files

    return $?
}

trap ctenv_exit INT TERM EXIT

function ctenv_self_extract
{
    local srcFile=${1:-}
    local tgtDir=${2:-}

    if [ -z ${tgtDir} ]; then
        return 1
    fi

    if [ ${tgtDir} = "." ]; then
        tgtDir="${CTENV_GCONST_MOBILE_SH_NAME%.*}"
    fi

    if [ -d ${tgtDir} ]; then
        ctenv_prt_error ${CTENV_GCONST_MOBILE_SH} \
            "target dir, ${tgtDir}, for extraction exists. please delete it first"
        return 1
    fi

    local -i CTENV_ARCHIVE_START=`awk '/^__CTENV_TAR_ARCHIVE_START__/ {print NR + 1; exit 0; }' ${srcFile}`
    if [ ${CTENV_ARCHIVE_START} -eq 0 ]; then
        ctenv_prt_error ${CTENV_GCONST_MOBILE_SH} \
            "nothing to extract from a file, ${srcFile}"
        return 1
    fi

    local -a fileList=(`tail -n+${CTENV_ARCHIVE_START} ${srcFile} | tar tjf -`)

    if [ ${#fileList[@]} -eq 0 ]; then
        ctenv_prt_error ${CTENV_GCONST_MOBILE_SH} \
            "nothing to extract from a file, ${srcFile}"
        return 1
    fi

    mkdir -p ${tgtDir}

    ctenv_prt_info ${CTENV_GCONST_MOBILE_SH} \
        "extracting files"

    tail -n+${CTENV_ARCHIVE_START} ${srcFile} | \
        tar -C ${tgtDir} -xvjf - | \
        xargs -I {} printf "\t%s\n" {}

    ctenv_prt_success ${CTENV_GCONST_MOBILE_SH} \
        "extraction complete"

    return 0
}

function ctenv_gen_zip_file
{
    local srcFile=${1:-}
    local tgtFile=${2:-}

    if [ -z ${tgtFile} ]; then
        return 1
    fi

    ctenv_prt_info ${CTENV_GCONST_MOBILE_SH} \
        "generating a zip"

    if [ ${tgtFile} = "." ]; then
        tgtFile="${CTENV_GCONST_MOBILE_SH_NAME%.*}.zip"
    fi

    if [ -f ${tgtFile} ]; then
        ctenv_prt_error ${CTENV_GCONST_MOBILE_SH} \
            "a file, ${tgtFile}, already exists. please delete it first"
        return 1
    fi

    ctenv_prt_info ${CTENV_GCONST_MOBILE_SH} \
        "step1: retrieving required files"

    local tmpDir=`ctenv_get_tmp_dir`
    ctenv_add_tmp_file_list ${tmpDir}

    # extract files to generate a patch
    rm -fr ${tmpDir}
    if ! ctenv_self_extract ${srcFile} ${tmpDir}; then
        ctenv_prt_error ${CTENV_GCONST_MOBILE_SH} \
            "failed to retrieve required files. stop here"
        return 1
    fi

    ctenv_prt_info ${CTENV_GCONST_MOBILE_SH} \
        "step2: creating a zip"

    local tmpFile=`ctenv_get_tmp_file`
    ctenv_add_tmp_file_list ${tmpFile}

    cd ${tmpDir}
    rm -f ${tmpFile}
    zip -9 -r ${tmpFile} *
    cd - &> /dev/null
    
    mv -f ${tmpFile} ${tgtFile}
    ctenv_prt_success ${CTENV_GCONST_MOBILE_SH} \
        "a file is generated successfully"

    return 0
}

# print usage at command level
function ctenv_prt_usage
{
    echo "Usage: ${CTENV_GCONST_MOBILE_SH_NAME} [options]"
    echo " + available options"
    echo "    -e [PATH]"
    echo "       extract files to [PATH]"
    echo "    -z [ZIP_FILE]"
    echo "       create a zip file, [ZIP_FILE]"

    return 0
}

#################################################################
# main function starts here
#

if [ $# -eq 0 ]; then
    ctenv_prt_usage
    exit 0
fi

while [ $# -gt 0 ]; do
	case "$1" in
        -e)
            if [ -z ${2:-} ]; then
                ctenv_prt_usage
                exit 1
            fi

            ctenv_self_extract `ctenv_readlink -f $0` $2
            shift
            ;;
        -z)
            if [ -z ${2:-} ]; then
                ctenv_prt_usage
                exit 1
            fi

            ctenv_gen_zip_file `ctenv_readlink -f $0` $2
            shift
            ;;
        *)
            ctenv_prt_usage
            exit 1
    esac
    shift
done

exit $?

#################################################################
# data starts here
#
