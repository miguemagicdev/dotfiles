#!/usr/bin/env zsh

# ================================
# 3. PLUGINS
# ================================

# Clone plugins if they don't exist
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.zsh}"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Source Plugins
source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Source Themes
source "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"

# Use local P10K configuration if exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
