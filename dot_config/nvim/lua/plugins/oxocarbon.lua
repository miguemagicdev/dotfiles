-- My IBM Carbon theme for LazyVim
return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    build = false,
    config = function()
      vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}
