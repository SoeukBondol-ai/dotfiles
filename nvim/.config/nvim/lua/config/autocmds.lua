local augroup = function(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Return to last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  desc = "Restore last cursor position",
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain utility buffers with just `q`
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "notify", "fugitive" },
  desc = "Close scratch/utility buffers with q",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Two-space indent for web/config filetypes (Prettier convention)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("web_indent"),
  pattern = {
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "html", "css", "scss", "json", "jsonc", "yaml", "markdown", "lua",
    "prisma",
  },
  desc = "Use 2-space indentation for web/config files",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Auto-create missing parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  desc = "Create missing parent directories on save",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return -- ignore URLs / non-file buffers
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
