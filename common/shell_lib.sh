
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
  WARP_EXPORT_DIR=`echo $WARP_EXPORT_DIR | perl -pe 's/\/$//g'`
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

exit_if_existent() {
  if [ -f "$1" ]; then
    touch $1
    echo "File already exist : $1, nothing to do"
    exit 0
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

secure_cd() {
  cd $1
  check_result
}

run() {
  CMD=$*
  # echo "Running system command _ $CMD _"
  if ! sh -c "$CMD"; then
    echo "Error while executing $CMD"
    exit 15
  fi
}

read_sys_dependencies() {
  SYS_DEPENDENCIES=""
  if [ -f ".warp_sys_dependencies" ]; then
    SYS_DEPENDENCIES=`cat .warp_sys_dependencies`
  else
    SYS_DEPENDENCIES="automatic"
  fi
}

automatic_update_sys_dependencies() {
  if [ "$SYS_DEPENDENCIES" = "automatic" ]; then
    TARGET=$1
    echo "Automatic system dependencies discovery for $TARGET"
    SYS_DEPENDENCIES=$($WARP_HOME/common/find_dependencies.sh $TARGET)
    echo "Sys dependencies found : $SYS_DEPENDENCIES"
  fi
}

generate_os_version() {
  if [ "$DISTRO_NAME" != "" ]; then
    echo $DISTRO_NAME
  else
    if [ `which lsb_release 2>&1 2> /dev/null` ]; then
      echo "`lsb_release -cs`_`arch`"
    else
      CONFIG=`ls /etc/*{release,version} 2> /dev/null | grep -v system | head -n 1`
      if [ -f $CONFIG ]; then
        NAME=`basename $CONFIG | awk -F- '{print $1}'`
        VERSION=`cat $CONFIG | head -n 1 | awk '{print $3}' | awk -F, '{print $1}' | awk -F. '{print $1}'`
        echo "${NAME}_${VERSION}_`arch`"
      else
        echo "Unable to detect distro"
        exit 1
      fi
    fi
  fi
}

tmpdir() {
  mktemp -d /tmp/warp.XXXXXX
}

load_lib() {
  . $WARP_HOME/common/$1/lib_$1.sh
}

check_warp_src() {
  if [ ! -f $HOME/.warp_src ]; then
    echo "No file \$HOME/.warp_src found"
    exit 42
  fi
  WARP_SRC=`cat $HOME/.warp_src | perl -pe 's/\/$//g'`
}

download_and_install() {
  FILENAME=$1
  check_warp_src
  TARGET_TMP_DIR=`tmpdir`
  TARGET=$TARGET_TMP_DIR/toto.warp
  echo "Downloading file $WARP_SRC/$FILENAME.warp"
  if ! curl -f -s $WARP_SRC/$FILENAME.warp -o $TARGET > /dev/null ; then
    echo "Unable to download file $WARP_SRC/$FILENAME.warp"
    rm -rf `dirname $TARGET`
    exit 87
  fi
  echo "File download successful"
  run sh $TARGET
  run rm -rf $TARGET_TMP_DIR
}

process_git_url() {
  GIT=$1
  if [ "$GIT_PREFIX" != "" ]; then
    GIT=$(echo $GIT | perl -pe "s/^git:/$GIT_PREFIX:/")
  fi
  echo $GIT
}

START_DIR=`pwd`
WARP_HOME=`cd $DIRNAME && cd $RELATIVE_WARP_HOME && pwd`

if [ "$git_protocol" = "" ]; then
  git_protocol="git"
fi

