local plugins = {
  require("plugins.colorscheme"),
  require("plugins.nvimtree"),
  require("plugins.livepreview"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
  require("plugins.cmp"),
  require("plugins.autopairs"),
  require("plugins.vimtex"),
  require("plugins.lualine"),
  require("plugins.tmux-navigator"),
  require("plugins.others"),
}

require("lazy").setup(plugins, {
  -- Lazy.nvim configuration options
  change_detection = {
    -- automatically check for plugin updates and reload when init.lua changes
    enabled = true,
    notify = false, -- get a notification when new updates are found
  },
})

