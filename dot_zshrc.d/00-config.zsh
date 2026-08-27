#!/usr/bin/env zsh

# ================================
# 1. ZSH CONFIGURATION
# ================================

# --------------------------------
# Profiling
# --------------------------------

# Load zprof module
# zmodload zsh/zprof

# Start profiling
# zprof

# --------------------------------
# ZSH options
# --------------------------------
setopt AUTO_CD              	# cd by typing directory name
setopt EXTENDED_HISTORY     	# Save timestamp and duration in history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY   	# Add commands to history as they are typed
setopt SHARE_HISTORY        	# Share history across sessions
setopt INTERACTIVE_COMMENTS 	# Allow comments in interactive shell

# --------------------------------
# History configuration
# --------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
