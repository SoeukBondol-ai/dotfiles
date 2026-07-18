-- Global options. Set the leader BEFORE lazy.nvim loads so mappings register correctly.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd Font is available (used by lualine, bufferline, neo-tree, noice icons).
vim.g.have_nerd_font = true

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (4 spaces by default; per-language overrides live in autocmds/formatters)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Wrapping & scrolling
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split" -- live preview of :substitute

-- Splits
opt.splitbelow = true
opt.splitright = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.laststatus = 3 -- global statusline (single lualine across splits)
opt.showmode = false -- lualine shows the mode
opt.colorcolumn = ""
opt.pumheight = 12 -- max items in completion popup
opt.mouse = "a"

-- Rounded borders for ALL floating windows (hover, signature, diagnostics, lazy, mason…).
-- Native to Neovim 0.11+.
opt.winborder = "rounded"

-- Files / persistence
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Completion behaviour (blink.cmp drives the menu; these are sane defaults)
opt.completeopt = "menuone,noselect"
opt.shortmess:append("c")

-- System clipboard
opt.clipboard = "unnamedplus"

-- Whitespace visualisation
opt.list = false
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Faster update / better UX
opt.updatetime = 250
opt.timeoutlen = 400 -- how long which-key waits before popping up

-- Treat these as part of filenames (e.g. gf on scoped npm packages)
opt.isfname:append("@-@")
