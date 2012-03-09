generate_node_version() {
  echo "node_$(generate_os_version)_$1"
}

load_node_config() {
  if [ -f package.json ]; then
    cat package.json | grep engines | sed s/[^0-9\.]//g > .node_version
    LOCAL_NODE_VERSION=`cat .node_version`
  fi
  if [ -f npm-shrinkwrap.json ]; then
    LOCAL_NPM_MODULES_HASH=`cat npm-shrinkwrap.json | md5sum | awk '{print $1}'`
  else
    if [ -f package.json ]; then
      LOCAL_NPM_MODULES_HASH=`cat package.json | md5sum | awk '{print $1}'`
    fi
  fi
}

generate_npm_modules() {
  echo "npm_modules_$(generate_os_version)_${LOCAL_NODE_VERSION}_${LOCAL_NPM_MODULES_HASH}"
}

nvm_command() {
  bash -c ". $NVM_DIR/nvm.sh && $*"
  if [ $? != "0" ]; then
    echo "Error while executing nvm command $*"
    exit 78
  fi
}

assert_nvm_installed() {
  if [ ! -d "$NVM_DIR" ]; then
    echo "nvm is not installed"
    exit 19
  fi
}

NVM_DIR="$HOME/.nvm"