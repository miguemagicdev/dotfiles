return {
  "lervag/vimtex",
  lazy = false, -- Needed to be loaded early for proper LaTeX workflow
   ft = "tex", -- Ensure it only loads for tex files
   config = function()
     vim.g.vimtex_view_method = 'okular'
  end
}

