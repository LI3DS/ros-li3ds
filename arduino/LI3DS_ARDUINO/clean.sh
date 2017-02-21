#!/bin/bash

if [ -d "build/" ]; then
cd build/
make clean
cd -
fi
