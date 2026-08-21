#!/usr/bin/env zsh

# ================================
# 2. PATH CONFIGURATION
# ================================

# User local bin directories
typeset -U PATH  # Remove duplicates
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nimble/bin"
    $path
)

# --------------------------------
# Java
# --------------------------------

# Java Home Directory
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# Make the Java binaries available
path=("$JAVA_HOME/bin" $path)

# --------------------------------
# Android SDK
# --------------------------------

# Root Directory of Android SDK
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

# Home Directory of Android SDK (same as Root Directory)
export ANDROID_HOME="$HOME/Android/Sdk"
path=(
    "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
    "$ANDROID_SDK_ROOT/platform-tools"
    "$ANDROID_SDK_ROOT/emulator"
    $path
)

export PATH
