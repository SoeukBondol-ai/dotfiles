-- Editing niceties: autopairs, surround, auto-close/rename tags, sessions.
-- Note: commenting uses Neovim's built-in `gc`/`gcc` (native since 0.10) — no
-- plugin needed.
return {
  -- Auto-insert matching brackets/quotes -------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
    },
  },

  -- Surround: add/change/delete surrounding pairs (sa/sd/sr) ------------------
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto close & auto rename HTML/JSX tags -----------------------------------
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html", "xml", "javascript", "javascriptreact",
      "typescript", "typescriptreact", "svelte", "vue", "markdown",
    },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },

  -- Session persistence (auto-save/restore per working directory) ------------
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    keys = {
      { "<leader>Ss", function() require("persistence").load() end, desc = "Restore session (cwd)" },
      { "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>Sd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },

  -- Indentation guides -------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- Diagnostics / quickfix list (Trouble) ------------------------------------
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list (Trouble)" },
    },
  },
}
