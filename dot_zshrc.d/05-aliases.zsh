#!/usr/bin/env zsh

# ================================
# 7. ALIASES AND FUNCTIONS
# ================================

# Alias that wraps nvim command
nvim() {
  # Source the file containing the necessary credentials
  source ~/.config/nvim/.env

  # Run Neovim
  command nvim "$@"
}
