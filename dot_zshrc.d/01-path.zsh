#!/usr/bin/env zsh

# ================================
# 2. PATH CONFIGURATION
# ================================

# User local bin directories
typeset -U PATH
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nimble/bin"
    $path
)

# --------------------------------
# Android SDK
# --------------------------------
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$HOME/Android/Sdk"
path=(
    "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
    "$ANDROID_SDK_ROOT/platform-tools"
    "$ANDROID_SDK_ROOT/emulator"
    $path
)

# --------------------------------
# Java
# --------------------------------

# Initialize SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Cache Java home to avoid repeated lookups
JAVA_CACHE="$HOME/.cache/java-home"
if [[ -f "$JAVA_CACHE" ]]; then
    export JAVA_HOME=$(cat "$JAVA_CACHE")
else
    mkdir -p "$HOME/.cache"
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
    echo "$JAVA_HOME" > "$JAVA_CACHE"
fi

path=("$JAVA_HOME/bin" $path)
export PATH
