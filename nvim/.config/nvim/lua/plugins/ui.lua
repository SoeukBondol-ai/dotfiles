-- UI: colorscheme, statusline, bufferline, command line, notifications, and Which-Key.
return {
  -- Tokyo Night theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      style = "night",
      transparent = false,

      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,

        component_separators = {
          left = "",
          right = "",
        },

        section_separators = {
          left = "",
          right = "",
        },

        disabled_filetypes = {
          statusline = {
            "neo-tree",
            "dashboard",
          },
        },
      },

      sections = {
        lualine_a = {
          "mode",
        },

        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
        },

        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },

        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
        },

        lualine_y = {
          "progress",
        },

        lualine_z = {
          "location",
        },
      },
    },
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    keys = {
      {
        "<S-h>",
        "<cmd>BufferLineCyclePrev<CR>",
        desc = "Previous buffer",
      },

      {
        "<S-l>",
        "<cmd>BufferLineCycleNext<CR>",
        desc = "Next buffer",
      },

      {
        "<leader>bP",
        "<cmd>BufferLinePickClose<CR>",
        desc = "Pick buffer to close",
      },

      {
        "<leader>bo",
        "<cmd>BufferLineCloseOthers<CR>",
        desc = "Close other buffers",
      },
    },

    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,

        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- Command-line popup, notifications, and LSP UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",

      {
        "rcarriga/nvim-notify",

        opts = {
          stages = "fade",
          timeout = 3000,
          render = "compact",
          top_down = false,
        },
      },
    },

    opts = {
      lsp = {
        -- Hide repeated basedpyright and other LSP progress messages.
        progress = {
          enabled = false,
        },

        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },

      routes = {
        {
          filter = {
            event = "lsp",
            kind = "progress",
          },

          opts = {
            skip = true,
          },
        },
      },

      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },

  -- Keybinding popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    opts = {
      preset = "modern",
      delay = 300,

      spec = {
        {
          "<leader>a",
          group = "AI / Agent",
        },

        {
          "<leader>b",
          group = "Buffer",
        },

        {
          "<leader>c",
          group = "Code",
        },

        {
          "<leader>e",
          group = "Explorer",
        },

        {
          "<leader>f",
          group = "Find",
        },

        {
          "<leader>g",
          group = "Git",
        },

        {
          "<leader>s",
          group = "Search / Replace",
        },

        {
          "<leader>S",
          group = "Session",
        },

        {
          "<leader>x",
          group = "Diagnostics / Trouble",
        },
      },
    },

    keys = {
      {
        "<leader>?",

        function()
          require("which-key").show({
            global = false,
          })
        end,

        desc = "Buffer local keymaps",
      },
    },
  },
}
