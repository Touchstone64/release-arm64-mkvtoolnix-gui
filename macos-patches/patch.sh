#! /usr/bin/env zsh

SCRIPT_DIR=$(dirname ${0})
SCRIPT_NAME=$(basename ${0})
MACOS_DIR="$1"
PATCH="$2"

if [[ ! -n ${MACOS_DIR} ]] || [[ ! -n ${PATH} ]]; then
    echo "usage: ${SCRIPT_NAME} <path to packaging/macos> <name of patch file>"
    exit 1
fi

echo "SCRIPT_DIR: ${SCRIPT_DIR}"
echo "MACOS_DIR: ${MACOS_DIR}"
echo "PATCH: ${PATCH}"

set -e 

# PATCH_PATH="${SCRIPT_DIR}/${PATCH}"

# echo "PATCH_PATH: ${PATCH_PATH}"

if [[ ! -f ${PATCH} ]]; then
    echo "${SCRIPT_NAME}: patch '${PATCH}' not found"
    exit 2
fi

TARGET=$(grep "+++" ${PATCH} | cut -f 1 | cut -d ' ' -f 2)
TARGET_PATH=${MACOS_DIR}/${TARGET}

echo "TARGET: ${TARGET}"
echo "TARGET_PATH: ${TARGET_PATH}"

if [[ ! -f ${TARGET_PATH} ]]; then
    echo "${SCRIPT_NAME}: target '${TARGET_PATH}' not found"
    exit 3
fi

# echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# echo "MACOS_DIR: ${MACOS_DIR}"
# echo "PATCH: ${PATCH}"
# echo "PATCH_PATH: ${PATCH_PATH}"
# echo "TARGET: ${TARGET}"
# echo "TARGET_PATH: ${TARGET_PATH}"

patch -d ${MACOS_DIR} -p1 < ${PATCH}

# if [[ -f ${TARGET} ]] && [[ -f ${PATCH_PATH} ]]; then
#     patch -d ${MACOS_DIR} -p1 < ${PATCH_PATH}
# fi
