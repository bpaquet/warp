
BIN_PATH=$RBENV_BIN_PATH
if [ ! -d $BIN_PATH/../lib ]; then
  BIN_PATH=`cd $BIN_PATH/../../../bin && pwd`
fi

export LD_LIBRARY_PATH="$BIN_PATH/../lib:$LD_LIBRARY_PATH"
if [ -f "$BIN_PATH/.rubylib" ]; then
  export RUBYLIB="`cat $BIN_PATH/.rubylib`:$RUBYLIB"
  export LD_LIBRARY_PATH="`cat $BIN_PATH/.rubylib`:$LD_LIBRARY_PATH"
fi