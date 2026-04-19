#! /usr/bin/env zsh

MACOS_DIR="$*"
SCRIPT_DIR=$(dirname ${0})
TARGET="${MACOS_DIR}/build.sh"
PATCH="${SCRIPT_DIR}/add-notarization.patch"

if [[ -f ${TARGET} ]] && [[ -f ${PATCH} ]]; then
    patch -d ${MACOS_DIR} -p1 < ${PATCH}
fi
