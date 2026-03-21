return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "python", "cpp", "c", "typescript", "css", "latex", "rust", "json",
        "markdown", "markdown_inline", "query", "vim", "vimdoc", "git_config",
        "git_rebase", "gitcommit", "diff", "bash", "yaml", "html",
        "javascript", "lua", "make", "fortran"
      },
      auto_install = true,
    })
  end
}

