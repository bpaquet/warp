
check_not_empty() {
  if [ "$1" = "" ]; then
    echo $SYNTAX
    exit 13
  fi
}

check_directory_exists() {
  check_not_empty $1
  if [ ! -d "$1" ]; then
    echo "Non existent directory : $1"
    exit 12
  fi 
}

check_mutiple_values() {
  check_not_empty $1
  VALUE=$1
  shift
  for i in $*; do
    if [ "$i" = "$VALUE" ]; then
      return 0
    fi
  done
  echo "Value : $VALUE not in list $*"
  exit 16
}

check_export_directory() {
  if [ "$WARP_EXPORT_DIR" = "" ]; then
    echo "Please set env variable WARP_EXPORT_DIR"
    exit 15
  fi
  if [ ! -d "$WARP_EXPORT_DIR" ]; then
    echo "WARP_EXPORT_DIR does not exist"
    exit 16
  fi
}

check_not_existent() {
  if [ -f "$1" ]; then
    echo "File already exist : $1"
    exit 18
  fi
}

check_existent() {
  if [ ! -f "$1" ]; then
    echo "File missing : $1"
    exit 19
  fi
}

check_result() {
  if [ $? != 0 ]; then
    echo "Last command failed"
    exit 20
  fi
}

assert_rbenv_installed() {
  if [ ! -d "$RBENV_DIR" ]; then
    echo "rbenv is not installed"
    exit 14
  fi
}

run() {
  CMD=$*
  # echo "Running system command _ $CMD _"
  if ! sh -c "$CMD"; then
    echo "Error while executing $CMD"
    exit 15
  fi
}

generate_os_version() {
  echo "`lsb_release -cs`_`arch`"
}

tmpdir() {
  echo `mktemp -d /tmp/warp.XXXXXX`
}

load_lib() {
  . $WARP_HOME/common/$1/lib_$1.sh
}

download_and_install() {
  FILENAME=$1
  WARP_SRC=`cat $HOME/.warp_src`
  TARGET=/tmp/toto.warp
  echo "Downloading file $WARP_SRC/$FILENAME.warp"
  curl -f -s $WARP_SRC/$FILENAME.warp -o $TARGET > /dev/null
  if [ "$?" != "0" ]; then
    echo "Unable to download file $WARP_SRC/$FILENAME.warp"
    rm -f $TARGET
    exit 87
  fi
  echo "File download successful"
  sh $TARGET
  check_result
  rm $TARGET
  check_result
}

START_DIR=`pwd`
WARP_HOME=`cd $DIRNAME && cd $RELATIVE_WARP_HOME && pwd`
RBENV_DIR="$HOME/.rbenv"