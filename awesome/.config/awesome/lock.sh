#!/bin/sh
set -e
xset s off dpms 0 10 0
dm-tool lock
xset s off -dpms
