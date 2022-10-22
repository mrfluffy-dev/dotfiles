#!/usr/bin/env sh

#run in the background
yes | cat >> test.txt &

sleep 10

killall yes

#show the size of test.txt in GB
du -b test.txt

rm test.txt
