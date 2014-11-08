cd src
make clean
./Configure linux-generic32 --prefix=/app --openssldir=/Apps/OpenSSL --install_prefix=/share/PackageBuilds/OpenSSL/package/x86
make
make test
make install

cd ../package
rm -rf build/
qbuild