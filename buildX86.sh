#!/bin/sh

# BEGIN - Change Variables for Platform, Architecture & Source Code Version
BUILD_PLATFORM="linux-generic32"
BUILD_ARCHITECTURE="x86"
SRC_ARCHIVE="openssl-1.0.1j.tar.gz"
# END - Change Variables for Platform, Architecture & Source Code Version

# Directory Variables
BUILD_ENV_DIR="../BuildEnvironments/$BUILD_ARCHITECTURE/sys-root"
SRC_DIR="appSrc/openssl"
BUILD_DIR="appBuild/openssl"
APP_PREFIX="/app"
APP_DIR="/Apps/OpenSSL"
APP_CONFIG_DIR="$APP_DIR/config"
PACKAGE_ENV="package/$BUILD_ARCHITECTURE"
PACKAGE_CONFIG="package/config"
PACKAGE_BUILD="package/build"

# Get the Script's Current Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Clean any Existing Source Code & Installed Binaries
rm -rf $BUILD_ENV_DIR/$SRC_DIR
rm -rf $BUILD_ENV_DIR/$BUILD_DIR

# Extract Source Code Archive
tar -xf --overwrite $SRC_ARCHIVE $BUILD_ENV_DIR/$SRC_DIR

# Clean, Build & Install the Source Code
chroot $BUILD_ENV_DIR make clean /$SRC_DIR
chroot $BUILD_ENV_DIR ./$SRC_DIR/Configure $BUILD_PLATFORM --prefix=$APP_PREFIX --openssldir=$APP_CONFIG_DIR --install_prefix=/$BUILD_DIR
chroot $BUILD_ENV_DIR make /$SRC_DIR
chroot $BUILD_ENV_DIR make test /$SRC_DIR
chroot $BUILD_ENV_DIR make install /$SRC_DIR

# Clean the QDK Package Environment
rm -rf $DIR/$PACKAGE_ENV/*
rm -rf $DIR/$PACKAGE_CONFIG/*
rm -rf $DIR/$PACKAGE_BUILD/

# Copy the Installed Binaries & Configs to the QDK Package Environment
cp $BUILD_ENV_DIR/$BUILD_DIR/$APP_CONFIG_DIR/* $DIR/$PACKAGE_CONFIG
cp $DIR/$INSTALL_PREFIX$APP_PREFIX/* $DIR/$PACKAGE_ENV

# Build the QPKG File
qbuild