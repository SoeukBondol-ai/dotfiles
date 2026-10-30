local servers = {
  "pyright",
  "ruff",
  "ts_ls",
  "eslint",
  "html",
  "cssls",
  "tailwindcss",
  "jsonls",
  "lua_ls",
  "emmet_language_server",
  "prismals",
  "gopls",
}

return {
  ---------------------------------------------------------------------------
  -- Mason
  ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",

    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUpdate",
      "MasonLog",
    },

    opts = {
      ui = {
        border = "rounded",

        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- LSP
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",

    event = {
      "BufReadPre",
      "BufNewFile",
    },

    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      -----------------------------------------------------------------------
      -- Diagnostics
      -----------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },

        underline = true,
        update_in_insert = false,
        severity_sort = true,

        float = {
          border = "rounded",
          source = true,
        },

        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      -----------------------------------------------------------------------
      -- nvim-cmp capabilities
      -----------------------------------------------------------------------
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -----------------------------------------------------------------------
      -- Python: Pyright
      -----------------------------------------------------------------------
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -----------------------------------------------------------------------
      -- Python: Ruff
      -----------------------------------------------------------------------
      vim.lsp.config("ruff", {
        on_attach = function(client)
          -- Let Pyright provide hover documentation.
          client.server_capabilities.hoverProvider = false
        end,
      })

      -----------------------------------------------------------------------
      -- TypeScript and JavaScript
      -----------------------------------------------------------------------
      vim.lsp.config("ts_ls", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
      })

      -----------------------------------------------------------------------
      -- ESLint
      -----------------------------------------------------------------------
      vim.lsp.config("eslint", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },
      })

      -----------------------------------------------------------------------
      -- HTML
      -----------------------------------------------------------------------
      vim.lsp.config("html", {
        filetypes = {
          "html",
          "templ",
        },
      })

      -----------------------------------------------------------------------
      -- CSS
      -----------------------------------------------------------------------
      vim.lsp.config("cssls", {
        filetypes = {
          "css",
          "scss",
          "less",
        },
      })

      -----------------------------------------------------------------------
      -- Tailwind CSS
      -----------------------------------------------------------------------
      vim.lsp.config("tailwindcss", {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },

        settings = {
          tailwindCSS = {
            classFunctions = {
              "cn",
              "clsx",
              "cva",
              "tw",
            },
          },
        },
      })

      -----------------------------------------------------------------------
      -- Emmet
      -----------------------------------------------------------------------
      vim.lsp.config("emmet_language_server", {
        filetypes = {
          "html",
          "css",
          "scss",
          "less",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "svelte",
        },
      })

      -----------------------------------------------------------------------
      -- JSON
      -----------------------------------------------------------------------
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            validate = {
              enable = true,
            },
          },
        },
      })

      -----------------------------------------------------------------------
      -- Lua
      -----------------------------------------------------------------------
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },

            diagnostics = {
              globals = {
                "vim",
              },
            },

            workspace = {
              checkThirdParty = false,

              library = {
                vim.env.VIMRUNTIME,
              },
            },

            telemetry = {
              enable = false,
            },

            hint = {
              enable = false,
            },
          },
        },
      })

      -----------------------------------------------------------------------
      -- Go
      -----------------------------------------------------------------------
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              unusedwrite = true,
            },
            staticcheck = true,
          },
        },
      })

      -----------------------------------------------------------------------
      -- Install non-LSP tools
      -----------------------------------------------------------------------
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettier",
        },

        run_on_start = true,
        start_delay = 1000,
        debounce_hours = 24,
      })

      -----------------------------------------------------------------------
      -- Install LSP servers
      -----------------------------------------------------------------------
      require("mason-lspconfig").setup({
        ensure_installed = servers,

        -- Enable only the servers in the list below.
        automatic_enable = false,
      })

      -----------------------------------------------------------------------
      -- Enable servers using Neovim's native LSP API
      -----------------------------------------------------------------------
      vim.lsp.enable(servers)

      -----------------------------------------------------------------------
      -- LSP keymaps
      -----------------------------------------------------------------------
      local group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,

        callback = function(event)
          local buffer = event.buf

          local function map(keys, action, description, mode)
            vim.keymap.set(mode or "n", keys, action, {
              buffer = buffer,
              silent = true,
              desc = "LSP: " .. description,
            })
          end

          -------------------------------------------------------------------
          -- Telescope LSP navigation
          -------------------------------------------------------------------
          local telescope_ok, telescope = pcall(require, "telescope.builtin")

          if telescope_ok then
            map("gd", telescope.lsp_definitions, "Go to definition")

            map("gr", telescope.lsp_references, "Find references")

            map("gI", telescope.lsp_implementations, "Go to implementation")

            map("gy", telescope.lsp_type_definitions, "Type definition")

            map("<leader>cs", telescope.lsp_document_symbols, "Document symbols")
          else
            map("gd", vim.lsp.buf.definition, "Go to definition")

            map("gr", vim.lsp.buf.references, "Find references")

            map("gI", vim.lsp.buf.implementation, "Go to implementation")

            map("gy", vim.lsp.buf.type_definition, "Type definition")
          end

          -------------------------------------------------------------------
          -- General LSP actions
          -------------------------------------------------------------------
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          map("K", vim.lsp.buf.hover, "Hover documentation")

          -- Ctrl+k is reserved for completion navigation.
          map("<C-g>", vim.lsp.buf.signature_help, "Signature help", "i")

          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")

          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })

          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")

          -------------------------------------------------------------------
          -- Diagnostic navigation
          -------------------------------------------------------------------
          map("]d", function()
            vim.diagnostic.jump({
              count = 1,
              float = true,
            })
          end, "Next diagnostic")

          map("[d", function()
            vim.diagnostic.jump({
              count = -1,
              float = true,
            })
          end, "Previous diagnostic")

          -------------------------------------------------------------------
          -- Inlay hints
          -------------------------------------------------------------------
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({
                bufnr = buffer,
              })

              vim.lsp.inlay_hint.enable(not enabled, {
                bufnr = buffer,
              })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },
}
