-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Basic Options
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.clipboard = "unnamedplus"

-- 3. Plugins
require("lazy").setup({
  { "B4mbus/oxocarbon-lua.nvim", lazy = false, priority = 1000, config = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("oxocarbon-lua")
    end 
  },
  
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = true },
      view = { side = "left", width = 30 },
      filters = { dotfiles = false },
    }
  },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      -- Neovim 0.11 uses the direct module for setup
      require("nvim-treesitter").setup({
        highlight = { enable = true },
        ensure_installed = { "python", "cpp", "cuda", "cmake", "bash", "yaml", "html", "javascript", "lua", "make", "fortran" },
      })
    end
  },

  -- LSP CONFIGURATION (SILENT 0.11 VERSION)
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { 
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local mlsp = require("mason-lspconfig")
      
      local servers = { 
        "basedpyright", "clangd", "cmake", "bashls", 
        "yamlls", "html", "ts_ls", "fortls", "texlab", "rust_analyzer" 
      }

      mlsp.setup({ ensure_installed = servers })

      local caps = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then caps = cmp_lsp.default_capabilities() end

      -- THE FIX: Bypass nvim-lspconfig's deprecated .setup() call
      -- We use the native vim.lsp.enable to stop the warnings
      for _, server in ipairs(servers) do
        local config = { capabilities = caps }
        
        if server == "clangd" then
          config.cmd = { "clangd", "--clang-tidy", "--background-index" }
        end

        -- This uses the NEW 0.11 native way if available, else falls back silently
        if vim.lsp.config then
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        else
          -- Fallback for older versions without warnings
          require("lspconfig")[server].setup(config)
        end
      end
    end
  },

  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'path' }, { name = 'buffer' } })
      })
    end
  },

  { "lervag/vimtex", lazy = false },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = 'auto', globalstatus = true } } },
  { "folke/snacks.nvim", priority = 1000, lazy = false, opts = { picker = { enabled = true } } },
  { "joshuavial/aider.nvim", opts = { terminal = "toggleterm", mapping = "<leader>a" } }
})

-- 4. Final Automations
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then require("nvim-tree.api").tree.open() end
  end
})

vim.api.nvim_create_user_command('Aider', function(args)
  require("aider").AiderOpen(args.args)
end, { nargs = '?', desc = "Open Aider with optional args" })
