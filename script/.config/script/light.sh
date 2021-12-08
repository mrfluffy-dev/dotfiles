#!/usr/bin/env bash

lightval=$(light -G | awk '{print int($float)}')
echo $lightval
