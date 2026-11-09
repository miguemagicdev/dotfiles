#!/usr/bin/env zsh

# ================================
# 3. ENVIRONMENT VARIABLES
# ================================

# --------------------------------
# Bitwarden SSH Agent
# --------------------------------
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"

# --------------------------------
# NVM (Node Version Manager)
# --------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"


# --------------------------------
# Podman
# --------------------------------
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock


# --------------------------------
# Cargo
# --------------------------------
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --------------------------------
# Improvements for builds
# --------------------------------
export OPENSSL_NO_VENDOR=1

# --------------------------------
# Preferences
# --------------------------------

# Use Neovim for opening buffers by default
export EDITOR=nvim
export VISUAL=nvim
