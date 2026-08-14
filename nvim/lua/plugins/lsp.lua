return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                jdtls = {},
            },
            setup = {
                jdtls = function()
                    return true -- Prevents lspconfig from automatically starting the server
                end,
            },
        },
    },
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
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP Go to definition" })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover Documentation" })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP Rename" })
            end

            -- List of LSP servers to install and set up
            local servers = {
                "basedpyright",
                "clangd",
                "bashls",
                "yamlls",
                "html",
                "ts_ls",
                "cssls",
                "fortls",
                "texlab",
                "rust_analyzer",
                "jsonls",
                "lua_ls",
                "angularls",
                "ansiblels",
                "jdtls",
                "kotlin_lsp",
            }

            require("mason-lspconfig").setup({
                ensure_installed = servers,
                -- This ensures that Mason will set up the servers' configurations when they are installed
                handlers = {
                    function(server_name)
                        if server_name == "jdtls" then
                            return
                        end
                        if server_name == "kotlin_lsp" then
                            return
                        end

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
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" }, -- lazy-load for kotlin files
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            local uv = vim.uv or vim.loop

            local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

            local root_dir = function(bufnr)
                local bufname = vim.api.nvim_buf_get_name(bufnr or 0)
                if bufname == "" then
                    return vim.fn.getcwd()
                end
                return vim.fs.root(bufname, root_markers)
            end

            local function get_cmd()
                local root = root_dir(vim.api.nvim_get_current_buf())
                local project_name = root and vim.fs.basename(root) or "unknown"
                local os_name = uv.os_uname().sysname:lower()
                local config_name
                if os_name:match("darwin") then
                    config_name = "config_mac"
                elseif os_name:match("windows") then
                    config_name = "config_win"
                else
                    config_name = "config_linux"
                end
                local mason_jdtls = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

                local cmd = {
                    "jdtls",
                    "-configuration",
                    mason_jdtls .. "/" .. config_name,
                    "-data",
                    vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name,
                }

                local lombok_jar = mason_jdtls .. "/lombok.jar"
                if vim.fn.filereadable(lombok_jar) == 1 then
                    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
                end

                return cmd
            end

            require("jdtls").start_or_attach({
                cmd = get_cmd,
                root_dir = root_dir,
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
                end,
                settings = { java = {} },
                init_options = { bundles = {} },
            })
        end,
    },
    {
        "AlexandrosAlexiou/kotlin.nvim",
        ft = { "kotlin" }, -- lazy-load for kotlin files
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("kotlin").setup({
                root_markers = { "build.gradle", "build.gradle.kts", "pom.xml", "mvnw" },
            })
        end,
    },
}
