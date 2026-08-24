#!/usr/bin/env zsh

# ================================
# 3. ENVIRONMENT VARIABLES
# ================================

# --------------------------------
# Bitwarden SSH Agent
# --------------------------------

# Integration with Bitwarden's SSH Agent
export SSH_AUTH_SOCK="$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"

# --------------------------------
# NVM (Node Version Manager)
# --------------------------------

# NVM Home Directory
export NVM_DIR="$HOME/.nvm"

# NVM Bash Completion
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --------------------------------
# SDKMAN
# --------------------------------
export SDKMAN_DIR="$HOME/.sdkman"

# Initialization script required for
# SDKMAN to work
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# --------------------------------
# Cargo
# --------------------------------

# Source the env file for
# Cargo to work
. "$HOME/.cargo/env"

# --------------------------------
# Fixes for builds
# --------------------------------

export OPENSSL_NO_VENDOR=1 # Fixes Neovim avante.nvim build process
