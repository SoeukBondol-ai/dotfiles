-- Core, plugin-independent keymaps. Plugin-specific maps live with each plugin spec.
local map = vim.keymap.set

-- Leave terminal input without consuming Escape (agents use it to cancel).
map("t", "<C-g>", [[<C-\><C-n>]], { desc = "Leave terminal input mode" })
for _, direction in ipairs({ "h", "j", "k", "l" }) do
  map("t", "<C-" .. direction .. ">", [[<C-\><C-n><C-w>]] .. direction, {
    desc = "Move from terminal to " .. direction .. " split",
  })
end

-- Clear search highlight
map("n", "<leader>nh", function()
  vim.cmd("nohlsearch")
  vim.fn.setreg("/", "")
end, { desc = "Clear search completely", silent = true })
map("i", "<C-c>", "<Esc>", { desc = "Escape from insert" })

-- Save / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Close window" })
map("n", "<leader>Q", "<cmd>quitall<CR>", { desc = "Quit all" })

-- Buffers
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Better up/down over wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
map("n", "J", "mzJ`z", { desc = "Join line, keep cursor" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep selection after indenting
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- Paste/delete without clobbering the yank register
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection (keep yank)" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Search & replace word under cursor
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Window navigation (tmux-navigator overrides <C-hjkl> when tmux is present;
-- these remain the fallback inside pure Neovim).
map("n", "<C-h>", "<C-w>h", { desc = "Go to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right split" })

-- Resize splits
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Diagnostics (buffer-agnostic; LSP-specific maps are in plugins/lsp.lua)
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Make current file executable
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
map("i", "jk", "<Esc>", { desc = "Exit Insert mode", silent = true })
