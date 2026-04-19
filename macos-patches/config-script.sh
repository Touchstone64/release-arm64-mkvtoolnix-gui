#! /usr/bin/env zsh

TARGET="$*/config.sh"
VAR_NAME="NOTARY_PROFILE"

match=$(grep ${VAR_NAME} ${TARGET})
if [[ ! -n ${match} ]]; then
    echo "patching file $(basename ${TARGET})"
    echo "export ${VAR_NAME}=\"\"" >> $TARGET
fi
