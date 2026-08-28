#!/usr/bin/env zsh

# ================================
# 5. COMPLETION
# ================================

# Cache compinit for speed
autoload -Uz compinit
if [[ -n $ZSH_DISABLE_COMPFIX ]]; then
    compinit -u -C
else
    compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Make Tab accept the suggestion
bindkey '^I' autosuggest-accept

# Set up fzf key bindings and fuzzy completions
source <(fzf --zsh)
