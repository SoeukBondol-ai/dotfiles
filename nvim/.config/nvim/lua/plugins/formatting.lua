-- Formatting (conform.nvim) and linting (nvim-lint).
return {
  -- conform.nvim: format on save + <leader>cf --------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer / selection",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        -- Prisma has no standalone CLI formatter; the Prisma LSP formats it,
        -- which conform reaches through the lsp_format fallback below.
        prisma = { lsp_format = "prefer" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        -- Allow disabling autoformat per-buffer/globally via a variable.
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
    },
    init = function()
      -- Toggle format-on-save at runtime.
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, { bang = true, desc = "Toggle format-on-save (!, buffer-local)" })
      vim.keymap.set("n", "<leader>cF", "<cmd>FormatToggle<CR>", { desc = "Toggle format on save" })
    end,
  },

  -- nvim-lint: extra linters (ESLint/Ruff diagnostics already come via LSP) ---
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      -- ESLint (JS/TS) and Ruff (Python) publish diagnostics through their
      -- language servers, so they are intentionally omitted here to avoid
      -- duplicate warnings. Add project-specific linters below as needed,
      -- e.g. markdown = { "markdownlint" }.
      lint.linters_by_ft = {}

      local group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          -- Only run when a linter is configured for this filetype.
          local names = lint.linters_by_ft[vim.bo.filetype]
          if names and #names > 0 then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
