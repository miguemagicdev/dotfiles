-- My noice.nvim overrides
return {
  {
    "folke/noice.nvim",
    opts = {
      -- Disable the command line popup
      -- I prefer the classic command line
      cmdline = {
        enabled = true,
        view = "cmdline", -- Fallback to the classic command line
        format = {
           -- Override command line icon to classic
           cmdline = { icon = ":" },
        },
      },

      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
      },
    },
  },
}
