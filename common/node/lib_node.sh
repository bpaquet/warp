generate_node_version() {
  echo "node_$(generate_os_version)_$1"
}

load_node_config() {
  if [ -f .nvmrc ] && [ -f .generated_node_version ] && [ -f package.json ]; then
    rm .nvmrc
  fi
  if [ -f .nvmrc ]; then
    LOCAL_NODE_VERSION=`cat .nvmrc`
  else
    if [ -f package.json ]; then
      cat package.json | $WARP_HOME/common/json.sh | grep '\["engines","node"\]' | awk '{print $2}' | perl -pe 's/"//g' > .nvmrc
      LOCAL_NODE_VERSION=`cat .nvmrc | grep -e '[[:digit:]]\.[[:digit:]]\.[[:digit:]]'`
      if [ "$LOCAL_NODE_VERSION" = "" ]; then
        echo "Wrong node version found in package.json : `cat .nvmrc`"
        rm .nvmrc
        exit 82
      fi
      touch .generated_node_version
    fi
  fi
  if [ -f .version_command ]; then
    LOCAL_NPM_MODULES_HASH=`sh .version_command | md5sum | awk '{print $1}'`
  else
    if [ -f npm-shrinkwrap.json ]; then
      LOCAL_NPM_MODULES_HASH=`cat npm-shrinkwrap.json | md5sum | awk '{print $1}'`
    else
      if [ -f package.json ] && [ "`grep dependencies package.json`" != "" ]; then
        LOCAL_NPM_MODULES_HASH=`cat package.json | md5sum | awk '{print $1}'`
      fi
    fi
  fi
  if [ -f .node_external_version_command ]; then
    LOCAL_NPM_MODULES_HASH="${LOCAL_NPM_MODULES_HASH}_$(bash .node_external_version_command)"
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