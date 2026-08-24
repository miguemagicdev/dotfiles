-- Tmux Integration with Neovim
return {
  "anoopkcn/split-jump.nvim",
  config = function()
    require("split-jump").setup({
      mappings = true,
      disable_when_zoomed = false,
      save_on_switch = 0,
      preserve_zoom = false,
      no_wrap = false,
      disable_netrw_workaround = true,
    })
  end,
}
