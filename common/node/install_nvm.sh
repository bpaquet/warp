#!/bin/sh

DIRNAME=`dirname $0`
RELATIVE_WARP_HOME=../../
. $DIRNAME/$RELATIVE_WARP_HOME/common/shell_lib.sh

NVM_TAG="60892c7b510d61f1fb50d3813de83cc9de614eca"

NVM_HAS_BEEN_INSTALLED=0

secure_cd $HOME

if [ ! -d .nvm ]; then
  echo "Cloning nvm"
  run git clone http://github.com/creationix/nvm.git .nvm
  NVM_HAS_BEEN_INSTALLED=1
fi

secure_cd .nvm

CURRENT_TAG=`git log --decorate -1 | grep $NVM_TAG`
if [ "$CURRENT_TAG" = "" ]; then
  echo "Updating nvm"
  run git checkout master
  run git pull
  run git checkout $NVM_TAG
fi

if [ "$NVM_HAS_BEEN_INSTALLED" = "1" ]; then
  for i in $HOME/.bashrc $HOME/.bash_profile $HOME/.zshrc; do
    if [ -f $i ]; then
      FOUND=`cat $i | grep '.nvm'`
      if [ "$FOUND" = "" ]; then
        echo "Modifying shell file : $i"
        echo "" >> $i
        check_result
        echo "# NVM CONFIG" >> $i
        echo '. $HOME/.nvm/nvm.sh' >> $i
      else
        echo "Startup files already modified"
      fi
      NVM_HAS_BEEN_INSTALLED=0
    fi
  done
fi
if [ "$NVM_HAS_BEEN_INSTALLED" = "1" ]; then
  echo "*****************************"
  echo "nvm has been installed, but we do not found your shell startup scripts"
  echo "To activate it in your shell, please add following lines to your startup script"
  echo ""
  echo '. $HOME/.nvm/nvm.sh'
  echo "*****************************"
fi
