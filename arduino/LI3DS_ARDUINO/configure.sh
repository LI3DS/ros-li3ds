#!/bin/bash
mkdir -p build/
cd build

# chemin vers le fichier tool-chain d'arduino-cmake
TOOLCHAIN_FILE=$ARDUINOCMAKE_DIR/cmake/ArduinoToolchain.cmake
# on lance la generation du projet via CMake
cmake -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE ..

cd -