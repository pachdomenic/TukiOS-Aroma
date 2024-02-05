#!/usr/bin/env bash

# Build script for Feather Project
# To be used when ones images are ready
# Call with the format ./build.sh FeatherProject_S22_T_v0.7.zip


if [ -z "$1" ]; then
    echo "Filename not provided"
    exit
fi

rm -f $1
zip -v -r $1 META-INF/com META-INF/scripts/bin mods rom device auxy debloat
