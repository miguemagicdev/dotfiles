#!/usr/bin/env zsh

# ================================
# 5. COMPLETION
# ================================

# Enable completion
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --------------------------------
# fzf-tab configuration
# --------------------------------

# Use the same colors as the default fzf-tab theme
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -la --color=always $realpath 2>/dev/null || ls -la --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -la --color=always $realpath 2>/dev/null || ls -la --color=always $realpath'

# Fallback: group results by type and keep them compact
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

bindkey '^ ' fzf-tab-complete
