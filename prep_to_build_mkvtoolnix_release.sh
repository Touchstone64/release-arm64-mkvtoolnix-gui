#! /usr/bin/env bash #-x

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(pwd)
DOCBOOK_XSL_NS_DIR="$HOMEBREW_PREFIX/opt/docbook-xsl/docbook-xsl-ns"

RELEASE="$*"

if [ -z "$RELEASE" ]; then
    echo "usage: $SCRIPT_NAME <release>, for example: $SCRIPT_NAME 98.0"
    exit 1
fi

set -e

RELEASE_DIR="$SCRIPT_DIR"/release-$RELEASE
if [ -d "$RELEASE_DIR" ]; then
    echo "Updating release-$RELEASE"
    cd "$RELEASE_DIR"
    git --no-optional-locks fetch --tags origin; git pull
    cd "$SCRIPT_DIR"
else
    git clone https://codeberg.org/mbunkus/mkvtoolnix --tag release-$RELEASE
fi

echo "Adding local config for XSLT and code-signing"
MACOS_DIR="$RELEASE_DIR/packaging/macos"
cat <<EOF > "$MACOS_DIR/config.local.sh"
export DOCBOOK_XSL_ROOT_DIR="$HOMEBREW_PREFIX/opt/docbook-xsl/docbook-xsl-ns"
export SIGNATURE_IDENTITY="Developer ID Application: Graham Thompson (H4MM26UAYB)"
EOF

RELEASE_QT_PATCH_DIR="$SCRIPT_DIR/qt-patches"
if [ -d "$RELEASE_QT_PATCH_DIR" ]; then
    echo "Adding QT patches"
    MACOS_QT_PATCH_DIR="$MACOS_DIR/qt-patches"
    mkdir -p "$MACOS_QT_PATCH_DIR"
    for i in "$RELEASE_QT_PATCH_DIR"/*.patch; do
        cp "$i" "$MACOS_QT_PATCH_DIR"/
    done
fi

# echo "Changing QT tarball build instruction"
# sed "s/  build_tarball command \"make DESTDIR=TMPDIR install\"/  build_tarball command \"cmake --install . --prefix 'TMPDIR\$TARGET'\"/g" ./build.sh > ./build2.sh
# mv ./build.sh ./build.sh.bak
# mv ./build2.sh ./build.sh
# chmod +x ./build.sh

# set +e
# diff build.sh.bak build.sh
# set -e

echo
# echo "If the only difference above is the QT build_tarball change (which we've just made), then you're ready to:"
echo "You're ready to:"
echo
echo "    cd $RELEASE_DIR/packaging/macos"
echo "    ./build.sh"
echo "    ./build.sh dmg"
echo
