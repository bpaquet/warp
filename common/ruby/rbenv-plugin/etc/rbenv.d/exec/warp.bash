export LD_LIBRARY_PATH="$RBENV_BIN_PATH/../lib:$LD_LIBRARY_PATH"
if [ -f "$RBENV_BIN_PATH/.rubylib" ]; then
  export RUBYLIB="`cat $RBENV_BIN_PATH/.rubylib`:$RUBYLIB"
fi