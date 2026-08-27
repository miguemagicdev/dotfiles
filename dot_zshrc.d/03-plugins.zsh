#!/usr/bin/env zsh

# ================================
# 4. PLUGINS
# ================================

# --------------------------------
# zinit (Zsh Plugin Manager)
# --------------------------------

# Auto-install zinit on first run
ZINIT_HOME="${ZINIT_HOME:-$HOME/.zinit}"
if [[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]]; then
    git clone --depth=1 https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/bin"
fi
source "$ZINIT_HOME/bin/zinit.zsh"

# --------------------------------
# Plugins
# --------------------------------

# Autosuggestions
zinit ice wait"0" lucid
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting
zinit ice wait"0" lucid
zinit light zsh-users/zsh-syntax-highlighting

# Tag Autopairs
zinit ice wait"0" lucid
zinit light hlissner/zsh-autopair

# Completions
zinit ice wait"1" as"completion" lucid
zinit light zsh-users/zsh-completions

# Powerlevel10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light romkatv/powerlevel10k

# Use local P10K configuration if exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
