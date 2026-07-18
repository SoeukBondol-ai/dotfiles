-- Navigation: fuzzy finder (Telescope), file explorer (Neo-tree), tmux panes.
return {
  -- Telescope: files, text, buffers, recent, symbols --------------------------
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep (live)" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = { "truncate" },
          file_ignore_patterns = {
            "%.git/", "node_modules/", "__pycache__/", "%.venv/", "dist/", "build/",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- Neo-tree: file explorer sidebar ------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ee", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>Neotree reveal<CR>", desc = "Reveal current file" },
      { "<leader>eg", "<cmd>Neotree git_status<CR>", desc = "Git status tree" },
      { "<leader>eb", "<cmd>Neotree buffers<CR>", desc = "Buffers tree" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".git", ".DS_Store" },
        },
        window = {
          mappings = {
            ["<leader>ee"] = "close_window",
          },
        },
      },
      window = {
        width = 32,
      },
      default_component_configs = {
        indent = { with_expanders = true },
      },
    },
  },

  -- Seamless navigation between Neovim splits and tmux panes -----------------
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate left (split/tmux)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate down (split/tmux)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate up (split/tmux)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (split/tmux)" },
    },
  },
}
