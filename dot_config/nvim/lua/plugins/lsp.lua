-- My LSP Configuration
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          settings = {
            java = {
              saveActions = {
                organizeImports = true,
                saveTheDocument = true,
                actions = {
                  source = {
                    removeUnusedPrivateMembers = true,
                    sortMembers = true,
                    addOverrideAnnotation = true,
                    useBlocks = true,
                    convertIterableLoop = true,
                    qualifyThis = true,
                  },
                },
              },
              cleanup = {
                enableDirtyState = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        lsp_fallback = true,
      },
    },
  },
}
