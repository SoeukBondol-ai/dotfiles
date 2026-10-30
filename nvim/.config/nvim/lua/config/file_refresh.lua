local M = {}

function M.check()
  -- Avoid reloading under a pending command or while the user is editing text.
  local mode = vim.api.nvim_get_mode().mode
  if (mode ~= "n" and mode ~= "nt" and mode ~= "t") or vim.fn.getcmdwintype() ~= "" then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and not vim.bo[buf].modified then
      -- Never discard unsaved work or prompt for conflicts from a background timer.
      pcall(vim.cmd, "silent checktime " .. buf)
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("user_file_refresh", { clear = true })
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave", "TermClose", "CursorHold" }, {
    group = group,
    desc = "Refresh unmodified files after external edits",
    callback = function()
      vim.schedule(M.check)
    end,
  })

  -- Terminal activity doesn't reliably trigger CursorHold or FocusGained.
  -- Poll loaded files so the code split refreshes while an agent is still running.
  if M.timer then
    M.timer:stop()
    M.timer:close()
  end
  M.timer = assert(vim.uv.new_timer())
  M.timer:start(500, 500, vim.schedule_wrap(M.check))
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      M.timer:stop()
      M.timer:close()
    end,
  })
end

return M
