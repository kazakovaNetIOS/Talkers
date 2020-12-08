if ! [[ -d "/usr/bin" ]]; then
  if ! mkdir -p "/usr/bin"; then
    echo >&2 "ERROR: cannot create '/usr/bin'"
  fi
fi
if ! ln -s /bin/env /usr/bin/env; then
  echo >&2 "ERROR: Unable to symlink env. Return code: $?"
fi

xcodebuild build-for-testing \
    -workspace 'Talkers.xcworkspace' \
    -scheme 'Talkers' \
    -destination 'platform=IOS Simulator,name=IPhone 11' #\
    #| xcpretty

echo 'SUCCESS!'