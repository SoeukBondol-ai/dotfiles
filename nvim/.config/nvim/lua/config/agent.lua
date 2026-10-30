-- Reusable native terminals, keyed by project directory and command.
local M = {}
local sessions = {}
local last_command = {}

local function project_root()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
    return vim.fs.root(buf, ".git") or vim.fn.getcwd()
  end
  return vim.b[buf].agent_root or vim.fn.getcwd()
end

function M.toggle(command)
  local root = project_root()
  command = command or last_command[root] or { "codex" }
  local key = root .. "\n" .. vim.json.encode(command)
  local session = sessions[key]

  if session and vim.api.nvim_buf_is_valid(session.buf) then
    local win = vim.fn.bufwinid(session.buf)
    if win ~= -1 then
      -- From code: focus the agent. From the agent: hide it, keeping it alive.
      if win == vim.api.nvim_get_current_win() then
        if #vim.api.nvim_tabpage_list_wins(0) > 1 then
          vim.api.nvim_win_close(win, false)
        else
          vim.cmd.enew()
        end
      else
        vim.api.nvim_set_current_win(win)
        vim.cmd.startinsert()
      end
      return
    end
    -- Keep exited terminals readable, but start a fresh process on the next toggle.
    if vim.fn.jobwait({ session.job }, 0)[1] ~= -1 then
      session = nil
    end
  else
    session = nil
  end

  if not session and vim.fn.executable(command[1]) ~= 1 then
    vim.notify("Agent executable not found: " .. command[1], vim.log.levels.WARN)
    return
  end
  last_command[root] = command

  -- Wide screens get a sidebar; narrow screens get a bottom terminal.
  if vim.o.columns >= 120 then
    vim.cmd("botright " .. math.floor(vim.o.columns * 0.42) .. "vsplit")
  else
    vim.cmd("botright " .. math.max(8, math.floor(vim.o.lines * 0.35)) .. "split")
  end

  if session then
    vim.api.nvim_win_set_buf(0, session.buf)
  else
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.b[buf].agent_root = root
    local job = vim.fn.jobstart(command, {
      term = true,
      cwd = root,
      on_exit = function()
        vim.schedule(function()
          require("config.file_refresh").check()
        end)
      end,
    })
    if job <= 0 then
      vim.api.nvim_win_close(0, true)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.notify("Could not start agent: " .. command[1], vim.log.levels.ERROR)
      return
    end
    vim.bo[buf].bufhidden = "hide"
    sessions[key] = { buf = buf, job = job }
    vim.keymap.set("n", "<leader>aa", function()
      M.toggle(command)
    end, { buffer = buf, desc = "Hide agent terminal" })
    vim.keymap.set("t", "<C-g>", function()
      vim.cmd.stopinsert()
      M.toggle(command)
    end, {
      buffer = buf,
      desc = "Hide agent terminal (session keeps running)",
    })
  end
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.cmd.startinsert()
end

function M.copy_reference(selection)
  local name = vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype ~= "" or name == "" then
    vim.notify("Open a code file first", vim.log.levels.INFO)
    return
  end
  local path = vim.fs.relpath(project_root(), name) or name
  local first, last = vim.fn.line("."), vim.fn.line(".")
  if selection then
    first, last = vim.fn.line("v"), vim.fn.line(".")
    first, last = math.min(first, last), math.max(first, last)
  end
  local reference = path .. ":" .. first .. (last ~= first and ("-" .. last) or "")
  vim.fn.setreg("+", reference)
  vim.notify("Copied for agent: " .. reference)
end

function M.setup()
  vim.api.nvim_create_user_command("Agent", function(opts)
    M.toggle(#opts.fargs > 0 and opts.fargs or nil)
  end, { nargs = "*", complete = "shellcmd", desc = "Toggle a project agent terminal (:Agent codex / claude / ...)" })

  local map = vim.keymap.set
  map("n", "<C-g>", function()
    M.toggle()
  end, { desc = "Toggle/focus last agent (default Codex)" })
  map("n", "<leader>aa", function()
    M.toggle()
  end, { desc = "Toggle/focus last agent (default Codex)" })
  map("n", "<leader>ac", function()
    M.toggle({ "codex" })
  end, { desc = "Codex terminal" })
  map("n", "<leader>al", function()
    M.toggle({ "claude" })
  end, { desc = "Claude terminal" })
  map("n", "<leader>at", function()
    M.toggle({ vim.o.shell })
  end, { desc = "Project shell terminal" })
  map("n", "<leader>ay", function()
    M.copy_reference(false)
  end, { desc = "Copy file:line for agent" })
  map("x", "<leader>ay", function()
    M.copy_reference(true)
  end, { desc = "Copy file:line-range for agent" })
  map("n", "<leader>ar", require("config.file_refresh").check, { desc = "Refresh externally changed files" })
end

return M
