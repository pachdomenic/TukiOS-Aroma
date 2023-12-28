#!/usr/bin/env bash

# Build script for Feather Project
# To be used when ones images are ready
# Call with the format ./build.sh FeatherProject_S22_T_v0.7.zip

supported_devices=("m31" "m21" "m31s" "a51" "f41")

if [ -z "$1" ]; then
    echo "Filename not provided"
    exit
fi

rm -f $1
zip -v -r $1 META-INF/com META-INF/scripts/bin mods img device auxy csc debloat featherproject.keys META-INF/scripts/xbin
