return {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Only load when entering insert mode for efficiency
    config = function()
        require("nvim-autopairs").setup({
            disable_filetype = { "TelescopePrompt", "vim", "Trouble", "terminal" },
            check_ts = true, -- Check treesitter nodes for smarter pairing
        })
    end,
}
