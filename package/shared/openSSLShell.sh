#!/bin/sh

  QPKG_NAME="OpenSSL"
  GETCFG_CMD="/sbin/getcfg"
  SETCFG_CMD="/sbin/setcfg"
  LOGTOOL_CMD="/sbin/log_tool"
  LOG_MSG_PREFIX="[App Center]"
  QPKG_SETTINGS="/etc/config/qpkg.conf"
  
  LINK_PATH="/Apps"
  LINK_BIN_PATH="$LINK_PATH/bin"
  APP_PATH="/app"
  APP_BIN_PATH="$APP_PATH/bin"
  INSTALL_PATH=""
  
  function log_info() {
    $LOGTOOL_CMD -t0 -uSystem -p127.0.0.1 -mlocalhost -a "$LOG_MSG_PREFIX $1"
  }
  
  function err_log() {
    $LOGTOOL_CMD -t2 -uSystem -p127.0.0.1 -mlocalhost -a "$LOG_MSG_PREFIX $1"
    echo  "$1" 1>&2
    exit 1
  }
  
  function check_enabled() {
    ENABLED=$($GETCFG_CMD $QPKG_NAME Enable -u -d FALSE -f $QPKG_SETTINGS)
    if [ "$ENABLED" != "TRUE" ]; then
      echo "$QPKG_NAME is disabled in App Center."
      exit 1
    fi
  }
  
  function get_install_path() {
    INSTALL_PATH=$($GETCFG_CMD $QPKG_NAME Install_Path -f $QPKG_SETTINGS)
    [ -z "$INSTALL_PATH" ] && err_log "$QPKG_NAME is not installed firmly."
  }
  
  function set_path_variable() {
    cat /etc/profile | grep "PATH" | grep "$LINK_PATH/bin:\$PATH" 1>>/dev/null 2>>/dev/null
    [ $? -ne 0 ] && /bin/echo "export PATH=$LINK_PATH/bin:\$PATH" >> /etc/profile
  }
  
  function create_links() {
    ln -nfs $INSTALL_PATH/$APP_PATH $LINK_PATH/OpenSSL
    ln -nfs $INSTALL_PATH/$APP_BIN_PATH/c_rehash $LINK_BIN_PATH/c_rehash
	ln -nfs $INSTALL_PATH/$APP_BIN_PATH/openssl $LINK_BIN_PATH/openssl
  }
  
  function destory_links() {
    rm -f $LINK_PATH/OpenSSL
    rm -f $LINK_BIN_PATH/c_rehash
	rm -f $LINK_BIN_PATH/openssl
  }
  
  case "$1" in
    debug)
	  set_path_variable
	  exit 1
	;;
  
    start)
      check_enabled
	  
	  echo "Getting Standard OpenSSL Install Path"
	  get_install_path
	  
	  echo "Setting PATH Variable & Creating Standard OpenSSL Symlinks"
	  set_path_variable
	  create_links
	  
	  echo "QNAP OpenSSL replaced with Standard OpenSSL."
	  log_info "QNAP OpenSSL replaced with Standard OpenSSL."
    ;;
    
    stop)
	  echo "Destroying Standard OpenSSL Symlinks"
      destory_links
	  echo "Standard OpenSSL replaced with QNAP OpenSSL."
	  log_info "Standard OpenSSL replaced with QNAP OpenSSL."
    ;;
	
	restart)
	  log_info "Restarting Standard OpenSSL"
      echo "Restarting Standard OpenSSL..."
      $0 stop
      $0 start
      echo "Done!"
    ;;
    
    *)
      echo "Usage: $0 {start|stop|restart}"
      exit 1
	;;
  esac
  
  exit 0
