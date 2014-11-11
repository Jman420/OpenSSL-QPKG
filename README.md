OpenSSL-QPKG
============

QPKG package repository for OpenSSL builds.


DEPENDENCIES
============

QNAP Toolchain for your architecture (http://www.qnap.com/dev/en/p_toolchain.php)

QDK (http://forum.qnap.com/viewtopic.php?f=128&t=36132)

OpenSSL Compile Dependencies (https://www.openssl.org/)


INSTRUCTIONS
============

./buildX86.sh

This script makes the following assumptions:
  - Your file system is setup as follows:
  
    [Root Folder]
	  - BuildEnvironments
	    - x86
		  - sys-root
		    - [Contents of sys-root folder from QNAP Toolchain]
	  - [OpenSSL Package Folder]
	    - [Contents of the git repository]
		
The script performs the following steps:
  1. Clean any Existing Source Code & Installed Binaries
  2. Make the Source, Build & Config Directories
  3. Extract Source Code Archive
  4. Clean, Build & Install the Source Code using chroot to specify the required Toolchain
  5. Clean the QDK Package Environment
  6. Copy the Installed Binaries & Configs to the QDK Package Environment
  7. Build the QPKG File


CONTRIBUTIONS
=============

Please contribute build scripts for more architectures.  I currently only have access to a 
QNAP TS-269Pro which is an x86 architecture, so I am not able to build for ARM architectures.
Thanks!
