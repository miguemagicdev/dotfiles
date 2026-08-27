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
      adapter = {
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            use_tools = true,
            env = {
              api_key = os.getenv("DEEPSEEK_API_KEY"),
            },
          })
        end,
      },
      default_adapter = "deepseek",
      strategies = {
        chat = {
          adapter = "deepseek",
          model = "deepseek-v4-pro",
        },
        inline = {
          adapter = "deepseek",
          model = "deepseek-v4-flash",
          keymaps = {
            accept_change = { modes = { n = "gda" } },
            reject_change = { modes = { n = "gdr" } },
            always_accept = { modes = { n = "gdy" } },
          },
        },
      },
      mcp = {
        default_tool_opts = {
          require_approval_before = true,
        },
        servers = {
          grep = {
            cmd = { "uvx", "mcp-server-grep" },
            disabled = false,
          },
          memory = {
            cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
            disabled = false,
          },
          fetch = {
            cmd = { "uvx", "mcp-server-fetch" },
            disabled = false,
          },
          filesystem = {
            cmd = { "npx", "-y", "@modelcontextprotocol/server-filesystem", vim.fn.getcwd() },
            disabled = false,
          },
          sequentialthinking = {
            cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
            disabled = false,
          },
          tavily = {
            cmd = { "npx", "-y", "tavily-mcp" },
            env = {
              TAVILY_API_KEY = os.getenv("TAVILY_API_KEY") or "",
            },
            disabled = not os.getenv("TAVILY_API_KEY"),
          },
          context7 = {
            cmd = { "npx", "-y", "@upstash/context7-mcp@latest" },
            disabled = false,
          },
          git = {
            cmd = { "uvx", "mcp-server-git", "--repository", vim.fn.getcwd() },
            disabled = false,
          },
          npm = {
            cmd = { "npx", "-y", "@modelcontextprotocol/server-npm" },
            disabled = false,
          },
          github = {
            cmd = {
              "podman",
              "run",
              "-i",
              "--rm",
              "-e",
              "GITHUB_PERSONAL_ACCESS_TOKEN",
              "-e",
              "GITHUB_READ_ONLY",
              "ghcr.io/github/github-mcp-server",
            },
            env = {
              GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN"),
              GITHUB_READ_ONLY = "true",
            },
            disabled = not os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN"),
          },
          gitlab = {
            cmd = { "npx", "-y", "@yoda.digital/gitlab-mcp-server" },
            env = {
              GITLAB_PERSONAL_ACCESS_TOKEN = os.getenv("GITLAB_PERSONAL_ACCESS_TOKEN"),
            },
            disabled = not os.getenv("GITLAB_PERSONAL_ACCESS_TOKEN"),
          },
          neovim = {
            disabled = true,
          },
        },
        opts = {
          default_servers = { "fetch", "tavily", "memory", "filesystem", "context7", "git", "sequentialthinking" },
          auto_start = true,
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
        diff = {
          provider = "default",
          opts = { "internal", "filler", "algorithm:histogram" },
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
