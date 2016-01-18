#!/usr/bin/env bash

launchctl load /Library/LaunchDaemons/org.apache.directory.server.plist
launchctl start org.apache.directory.server