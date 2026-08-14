vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only open nvim-tree if no files were opened at startup
        if #vim.api.nvim_list_bufs() == 1 and vim.api.nvim_buf_get_name(vim.api.nvim_list_bufs()[1]) == "" then
            require("nvim-tree.api").tree.open()
        end
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("MyWindowResizer", { clear = true }),
    callback = function()
        vim.cmd("wincmd =")
    end,
})
