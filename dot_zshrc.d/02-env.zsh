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
