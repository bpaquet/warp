generate_ruby_version() {
  echo "ruby_$(generate_os_version)_$1"
}

generate_gemset() {
  echo "gemset_$(generate_os_version)_${LOCAL_RUBY_VERSION}_${LOCAL_GEMSET}_${LOCAL_GEMSET_HASH}"
}

load_ruby_config() {
  LOCAL_RUBY_VERSION=`[ -f .rbenv-version ] && cat .rbenv-version`
  LOCAL_GEMSET=`[ -f .rbenv-gemsets ] && cat .rbenv-gemsets`
  LOCAL_BUNDLE_OPTIONS=`[ -f .bundle-option ] && cat .bundle-option`
  LOCAL_GEMSET_HASH=`(cat Gemfile.lock && echo $LOCAL_BUNDLE_OPTIONS) | md5sum | awk '{print $1}'`
}