#!/bin/sh

# Run as root

install -o root -g wheel -m 755 -d /usr/local/bin/
install -o root -g wheel -m 755 -d /usr/local/etc/

install -o root -g wheel -m 400 highway-patrol.conf /usr/local/etc/
install -o root -g wheel -m 500 highway-patrol.sh   /usr/local/bin/
install -o root -g wheel -m 400 com.logcheck.highway-patrol.plist /Library/LaunchDaemons/

launchctl load -w /Library/LaunchDaemons/com.logcheck.highway-patrol.plist
