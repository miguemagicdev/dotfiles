return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
    },
    lazy = false,
    opts = {
      interactions = {
        chat = {
          adapter = "opencode",
          model = "deepseek/deepseek-v4-pro",
        },
        inline = {
          adapter = "opencode",
          model = "deepseek/deepseek-v4-pro",
        },
        cli = {
          agent = "opencode",
          agents = {
            opencode = {
              cmd = "opencode",
              args = {},
              description = "OpenCode CLI agent",
              provider = "terminal",
            },
          },
        },
        shared = {
          keymaps = {
            accept_change = { modes = { n = "gda" } },
            reject_change = { modes = { n = "gdr" } },
            always_accept = { modes = { n = "gdy" } },
          },
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            auto_save = true,
            save_chat_keymap = "sc",
            continue_last_chat = true,
          },
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.35,
            full_height = true,
            position = "right",
          },
        },
      },
      prompt_library = {
        ["review"] = {
          description = "Review the current code",
          strategy = "chat",
          prompts = {
            {
              role = "user",
              content = "Please review the code in the current buffer for bugs, performance issues, and maintainability. Be specific in your suggestions.",
            },
          },
        },
        ["commit"] = {
          description = "Generate a conventional commit message",
          strategy = "inline",
          prompts = {
            {
              role = "user",
              content = "Generate a conventional commit message for the current git changes. Format: type(scope): message",
            },
          },
        },
        ["refactor"] = {
          description = "Refactor the selected code",
          strategy = "inline",
          prompts = {
            {
              role = "user",
              content = "Refactor this code to be more maintainable, readable, and efficient. Explain your changes.",
            },
          },
        },
        ["explain"] = {
          description = "Explain the selected code",
          strategy = "inline",
          prompts = {
            {
              role = "user",
              content = "Explain this code in detail, including what it does, how it works, and any potential issues.",
            },
          },
        },
        ["test"] = {
          description = "Generate unit tests",
          strategy = "inline",
          prompts = {
            {
              role = "user",
              content = "Generate comprehensive unit tests for this code using the appropriate testing framework.",
            },
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "codecompanion" },
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "codecompanion" },
      })
    end,
  },
}
