OpenSSL-QPKG
============

QPKG package repository for OpenSSL builds.


DEPENDENCIES
============

QDK (http://forum.qnap.com/viewtopic.php?f=128&t=36132)

OpenSSL Compile Dependencies (https://www.openssl.org/)


INSTRUCTIONS
============

./buildX86.sh

This script performs the following steps:
  1. Clean any existing build of OpenSSL
  2. Configure the OpenSSL build for linux-generic32, to install binaries to /app, to 
     install configuration files to /Apps/OpenSSL, set install prefix as 
     <Repository Path>/package/x86
  3. Build OpenSSL
  4. Test the Completed OpenSSL Build
  5. Install the Completed OpenSSL Build to the OpenSSL QDK Package Directory
  6. Clean any OpenSSL QPKG Builds
  7. Build the OpenSSL QPKG (see <Repository Path>/package/builds/)
