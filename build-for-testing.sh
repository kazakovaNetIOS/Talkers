#!/usr/bin/env bash

xcodebuild build-for-testing \
    -workspace 'Talkers.xcworkspace' \
    -scheme 'Talkers' \
    -destination 'platform=IOS Simulator,name=IPhone 11' #\
    #| xcpretty

echo 'SUCCESS!'