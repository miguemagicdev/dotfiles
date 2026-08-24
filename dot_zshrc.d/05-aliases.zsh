#!/usr/bin/env zsh

# ================================
# 6. ALIASES AND FUNCTIONS
# ================================

# Sets DEEPSEEK_API_KEY securely
ds-api() {
  read -s "DEEPSEEK_API_KEY?Enter API Key: "
  export  DEEPSEEK_API_KEY
}

# Sets TAVILY_API_KEY securely
tv-api() {
  read -s "TAVILY_API_KEY?Enter API Key: "
  export  TAVILY_API_KEY
}
