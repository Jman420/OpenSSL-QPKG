APP_PREFIX="/app"
APP_DIR="/Apps/OpenSSL"
APP_CONFIG_DIR="$APP_DIR/config"
INSTALL_PREFIX="package/x86"

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR/$INSTALL_PREFIX
rm -rf *

cd $DIR/src
make clean
./Configure linux-generic32 --prefix=$APP_PREFIX --openssldir=$APP_CONFIG_DIR --install_prefix=$DIR/$INSTALL_PREFIX
make
make test
make install

cd $DIR/package
rm -rf build/
mv $DIR/$INSTALL_PREFIX/$APP_DIR/* $DIR/$INSTALL_PREFIX
rm -rf $DIR/$INSTALL_PREFIX/Apps
mv $DIR/$INSTALL_PREFIX$APP_PREFIX/* $DIR/$INSTALL_PREFIX
rm -rf $DIR/$INSTALL_PREFIX$APP_PREFIX

qbuild
