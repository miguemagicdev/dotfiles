return {
  "B4mbus/oxocarbon-lua.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    vim.cmd.colorscheme("oxocarbon-lua")
  end
}

