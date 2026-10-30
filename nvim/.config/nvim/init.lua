vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.agent").setup()
require("config.lazy")
