#!/usr/bin/env zsh

# ================================
# 7. ALIASES AND FUNCTIONS
# ================================

# Alias that wraps nvim command
nvim() {
  # Source the file containing the necessary credentials
  source ~/.config/nvim/.env

  # Export the sourced variables
  export TAVILY_API_KEY
  export GITHUB_PERSONAL_ACCESS_TOKEN
  export GTITLAB_PERSONAL_ACCESS_TOKEN

  # Run Neovim
  command nvim "$@"
}
