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
lazy_load_nvm() {
  unfunction npm npx node 2>/dev/null
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}
npm() { lazy_load_nvm && npm "$@"; }
npx() { lazy_load_nvm && npx "$@"; }
node() { lazy_load_nvm && node "$@"; }


# --------------------------------
# Cargo
# --------------------------------
lazy_load_cargo() {
  unfunction cargo 2>/dev/null
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
}

cargo() { lazy_load_cargo && cargo "$@"; }

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
