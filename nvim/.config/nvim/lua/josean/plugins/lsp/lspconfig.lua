return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    -- Optional but very recommended: auto-install LSP servers
    { "williamboman/mason-lspconfig.nvim" },
  },

  config = function()
    -- Make sure mason-lspconfig knows which servers to install
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",
        "ts_ls",
        "lua_ls",
        "emmet_ls",
        "eslint",
        "graphql",
        -- "svelte",           -- if using svelte LSP
        -- "sqls",             -- if needed
      },
      automatic_installation = true, -- auto install when first used
    })

    -- Capabilities for nvim-cmp integration
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Global LSP attach keymaps & settings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- Better diagnostic signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      virtual_text = true, -- show inline diagnostics
      underline = true,
      update_in_insert = false, -- better performance
      severity_sort = true,
    })

    -- ──────────────────────────────────────────────────────────────
    -- Server-specific configurations
    -- ──────────────────────────────────────────────────────────────

    vim.lsp.config.pyright = {
      capabilities = capabilities,
      before_init = function(_, config)
        local handle = io.popen("uv python find 2>/dev/null")
        if handle then
          local uv_python = handle:read("*a"):gsub("\n", "")
          handle:close()
          if vim.fn.filereadable(uv_python) == 1 then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = uv_python
          end
        end
      end,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            typeCheckingMode = "basic", -- "basic" / "standard" / "strict"
            diagnosticMode = "openFilesOnly", -- faster, less noise (or "workspace")
            diagnosticSeverityOverrides = {
              reportMissingTypeStubs = "none",
              reportUnknownArgumentType = "warning",
              reportUnknownVariableType = "warning",
              reportMissingModuleSource = "none",
            },
          },
        },
      },
    }

    vim.lsp.config.ts_ls = {
      capabilities = capabilities,
      settings = {
        implicitProjectConfiguration = {
          checkJs = true,
        },
      },
    }

    vim.lsp.config.svelte = {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Auto-reload on .js/.ts changes (useful for Svelte + TS)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
          buffer = bufnr,
        })
      end,
    }

    vim.lsp.config.graphql = {
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    }

    vim.lsp.config.emmet_ls = {
      capabilities = capabilities,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    }

    vim.lsp.config.eslint = {
      capabilities = capabilities,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    }

    vim.lsp.config.sqls = {
      capabilities = capabilities,
      filetypes = { "sql", "mysql" },
    }

    vim.lsp.config.lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    -- Enable all configured servers
    vim.lsp.enable({
      "pyright",
      "ts_ls",
      "svelte",
      "graphql",
      "emmet_ls",
      "eslint",
      "sqls",
      "lua_ls",
    })
  end,
}
