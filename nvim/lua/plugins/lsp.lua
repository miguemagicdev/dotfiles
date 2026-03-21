return {
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- If nvim-cmp is used, integrate its capabilities
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_lsp.default_capabilities()
      end

      -- Define common `on_attach` function for all LSPs
      local on_attach = function(client, bufnr)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'LSP Go to definition' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP Hover Documentation' })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP Rename' })
      end

      -- List of LSP servers to install and set up
      local servers = {
        "basedpyright", "clangd", "bashls", "yamlls", 
        "html", "ts_ls", "cssls", "fortls", "texlab",
        "rust_analyzer", "jsonls", "lua_ls", "angularls",
        "ansiblels",
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        -- This ensures that Mason will set up the servers' configurations when they are installed
        handlers = {
          function(server_name)
            local config = {
              on_attach = on_attach,
              capabilities = capabilities,
            }

            if server_name == "clangd" then
              config.cmd = { "clangd", "--clang-tidy", "--background-index", "--header-insertion=never" }
            end
            require("lspconfig")[server_name].setup(config)
          end,
        },
      })
    end,
  },
}

