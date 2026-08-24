-- My Avante Configuration
return {
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  version = false,
  commit = "7f90a3390e0342957ac0b36414e06c2acf1f60b3",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "folke/snacks.nvim",
    {
      -- Support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "Avante" },
      },
      ft = { "Avante" },
    },
  },

  opts = {
    provider = "deepseek",
    mode = "legacy",
    instructions_file = "AGENTS.md",
    providers = {
      deepseek = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-v4-flash",
        timeout = 30000,
        extra_request_body = {
          max_tokens = 32768,
          thinking = { type = "disabled" },
        },
      },
    },

    web_search_engine = {
      provider = "tavily",
      providers = {
        tavily = {
          api_key_name = "TAVILY_API_KEY",
          extra_request_body = {
            include_answer = "basic",
          },
        },
      },
    },

    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
    },

    -- These must be set for the UI
    highlights = {
      diff = {
        mode = "diff",
      },
    },

    history = {
      max_entries = 50,
      auto_clean = true,
    },

    global_dir = vim.fn.expand("~/.config/avante/rules"),
    project_dir = ".avante/rules",
  },
}
