#!/bin/sh

# BEGIN - Change Variables for Platform, Architecture & Source Code Version
BUILD_PLATFORM="linux-generic32"
BUILD_ARCHITECTURE="x86"
ARCHIVE_NAME="openssl-1.0.1j"
SRC_ARCHIVE="$ARCHIVE_NAME.tar.gz"
# END - Change Variables for Platform, Architecture & Source Code Version

# Directory Variables
BUILD_ENV_DIR="BuildEnvironments/$BUILD_ARCHITECTURE/sys-root"
APP_PREFIX="OpenSSL"
SRC_TAR_ROOT="openssl"
SRC_DIR="appSrc/$SRC_TAR_ROOT"
BUILD_DIR="appBuild/$APP_PREFIX"
CONFIG_DIR="Apps/$APP_PREFIX/config"
QPKG_DIR="package"
QPKG_ENV="$QPKG_DIR/$BUILD_ARCHITECTURE"
QPKG_CONFIG="$QPKG_ENV/config"
QPKG_BUILD="$QPKG_DIR/build"

# Get the Script's Current Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
PACKAGE_ROOT="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
PACKAGE_PARENT="$(dirname "$PACKAGE_ROOT")"

# Clean any Existing Source Code & Installed Binaries
rm -rf $PACKAGE_PARENT/$BUILD_ENV_DIR/$SRC_DIR
rm -rf $PACKAGE_PARENT/$BUILD_ENV_DIR/$BUILD_DIR
rm -rf $PACKAGE_PARENT/$BUILD_ENV_DIR/$CONFIG_DIR

# Extract Source Code Archive
mkdir -p $PACKAGE_PARENT/$BUILD_ENV_DIR/$SRC_DIR
mkdir -p $PACKAGE_PARENT/$BUILD_ENV_DIR/$BUILD_DIR
mkdir -p $PACKAGE_PARENT/$BUILD_ENV_DIR/$CONFIG_DIR
tar -xf $SRC_ARCHIVE -C $PACKAGE_PARENT/$BUILD_ENV_DIR/$SRC_DIR

# Clean, Build & Install the Source Code
chroot $PACKAGE_PARENT/$BUILD_ENV_DIR bash -c "cd /$SRC_DIR/$ARCHIVE_NAME && make clean"
chroot $PACKAGE_PARENT/$BUILD_ENV_DIR bash -c "cd /$SRC_DIR/$ARCHIVE_NAME && ./Configure $BUILD_PLATFORM --prefix=/$BUILD_DIR --openssldir=/$CONFIG_DIR && make && make test && make install"

# Clean the QDK Package Environment
rm -rf $PACKAGE_ROOT/$QPKG_ENV/*
rm -rf $PACKAGE_ROOT/$QPKG_BUILD/

# Copy the Installed Binaries & Configs to the QDK Package Environment
mkdir -p $PACKAGE_ROOT/$QPKG_CONFIG
cp -r $PACKAGE_PARENT/$BUILD_ENV_DIR/$BUILD_DIR/* $PACKAGE_ROOT/$QPKG_ENV
cp -r $PACKAGE_PARENT/$BUILD_ENV_DIR/$CONFIG_DIR/* $PACKAGE_ROOT/$QPKG_CONFIG

# Build the QPKG File
qbuild --root $PACKAGE_ROOT/$QPKG_DIR
