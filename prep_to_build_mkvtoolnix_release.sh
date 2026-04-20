#! /usr/bin/env zsh #-x

SCRIPT_NAME=$(basename ${0})
SCRIPT_DIR=$(pwd)

RELEASE_VERSION="$*"

if [[ -z ${RELEASE_VERSION} ]]; then
    echo "usage: ${SCRIPT_NAME} <release>, for example: ${SCRIPT_NAME} 98.0"
    exit 1
fi

set -e

RELEASE_TAG="release-${RELEASE_VERSION}"
RELEASE_DIR=${SCRIPT_DIR}/${RELEASE_TAG}
git clone -c advice.detachedHead=false \
    --depth 1 --branch ${RELEASE_TAG} \
    https://codeberg.org/mbunkus/mkvtoolnix \
    ${RELEASE_DIR}

echo "Creating config.local.sh for code-signing and notarization"
MACOS_DIR=${RELEASE_DIR}/packaging/macos
cat <<EOF > ${MACOS_DIR}/config.local.sh
export SIGNATURE_IDENTITY="Developer ID Application: Graham Thompson (H4MM26UAYB)"
export NOTARY_PROFILE="NotaryProfile"
EOF

RELEASE_QT_PATCH_DIR=${SCRIPT_DIR}/qt-patches
if [[ -d ${RELEASE_QT_PATCH_DIR} ]]; then
    echo "Adding QT patches..."
    MACOS_QT_PATCH_DIR=${MACOS_DIR}/qt-patches
    mkdir -p ${MACOS_QT_PATCH_DIR}
    for i in ${RELEASE_QT_PATCH_DIR}/*.patch; do
        echo "copying $(basename $i) ready for build.sh"
        cp "$i" ${MACOS_QT_PATCH_DIR}/
    done
fi

RELEASE_MACOS_PATCH_DIR=${SCRIPT_DIR}/macos-patches
if [[ -d ${RELEASE_MACOS_PATCH_DIR} ]]; then
    echo "Applying packaging/macos patches..."
    for i in ${RELEASE_MACOS_PATCH_DIR}/*.sh; do
        "$i" ${MACOS_DIR}
    done
fi

echo
echo "You're ready to:"
echo
echo "    cd ./${RELEASE_TAG}/packaging/macos"
echo "    ./build.sh"
echo "    ./build.sh dmg"
echo
