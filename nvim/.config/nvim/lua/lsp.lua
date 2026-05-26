require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "pyright",
        "ruff",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
    },
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

-- Python: pyright for types/navigation, ruff for linting/formatting
vim.lsp.config("pyright", {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
            },
            venvPath = ".",
            venv = ".venv",
        },
    },
})

vim.lsp.config("ruff", {
    -- ruff provides diagnostics, formatting, and code actions
    -- pyright handles type checking and navigation
})

-- TypeScript / JavaScript / React
vim.lsp.config("ts_ls", {})

-- HTML & CSS
vim.lsp.config("html", {})
vim.lsp.config("cssls", {})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
    "pyright",
    "ruff",
    "ts_ls",
    "html",
    "cssls",
})