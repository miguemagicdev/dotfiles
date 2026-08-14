return {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        require("live-preview").setup({})
    end,
}
