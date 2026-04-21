#! /usr/bin/env zsh

SCRIPT_DIR=$(dirname ${0})
SCRIPT_NAME=$(basename ${0})
MACOS_DIR="$1"
PATCH="$2"

if [[ ! -n ${MACOS_DIR} ]] || [[ ! -n ${PATCH} ]]; then
    echo "usage: ${SCRIPT_NAME} <path to packaging/macos> <name of patch file>"
    exit 1
fi

if [[ ! -f ${PATCH} ]]; then
    echo "${SCRIPT_NAME}: patch '${PATCH}' not found"
    exit 2
fi

set -e 

TARGET=$(grep "+++" ${PATCH} | cut -f 1 | cut -d ' ' -f 2)
TARGET_PATH=${MACOS_DIR}/${TARGET}

if [[ ! -f ${TARGET_PATH} ]]; then
    echo "${SCRIPT_NAME}: target '${TARGET_PATH}' not found"
    exit 3
fi

patch -d ${MACOS_DIR} -p1 < ${PATCH}
