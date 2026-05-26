vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/nvim-telescope/telescope.nvim",
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "https://github.com/linux-cultist/venv-selector.nvim",
})

-- mini files ----
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })
vim.keymap.set("n", "<leader>ee", function() MiniFiles.open() end, { desc = "Open file explorer" })

---- mini notify ----
require("mini.notify").setup({
	-- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmdline completion ---
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions --- 
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
	source = MiniDiff.gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })

--- mini clue (which-key) ---
local MiniClue = require("mini.clue")
MiniClue.setup({
    triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "s", },
    },
    clues = {
        MiniClue.gen_clues.builtin_completion(),
        MiniClue.gen_clues.g(),
        MiniClue.gen_clues.marks(),
        MiniClue.gen_clues.registers(),
        -- mini.clue descriptions for leader key groups
        { mode = "n", keys = "<Leader>p", desc = "Pick/Finder" },
        { mode = "n", keys = "<Leader>e", desc = "Explorer" },
        { mode = "n", keys = "<Leader>g", desc = "Git" },
        { mode = "n", keys = "<Leader>t", desc = "Telescope" },
        { mode = "n", keys = "<Leader>v", desc = "Venv" },
        { mode = "n", keys = "<Leader>x", desc = "Diagnostics/Quickfix" },
    },
    window = { delay = 400 },
})

--- telescope ---
require("telescope").setup({
    defaults = {
        file_ignore_patterns = { ".git/", "node_modules/", "__pycache__/", ".venv/" },
    },
})
pcall(require("telescope").load_extension, "fzf")

vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope Live Grep" })
vim.keymap.set("n", "<leader>tb", "<cmd>Telescope buffers<cr>", { desc = "Telescope Buffers" })
vim.keymap.set("n", "<leader>th", "<cmd>Telescope help_tags<cr>", { desc = "Telescope Help" })
vim.keymap.set("n", "<leader>to", "<cmd>Telescope oldfiles<cr>", { desc = "Telescope Recent Files" })
vim.keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Diagnostics" })

--- venv-selector (auto-detect uv/venv) ---
require("venv-selector").setup({
    auto_refresh = true,
    search = {
        venvs = {
            ".venv",
            "venv",
        },
    },
})

vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select Python Venv" })