-- Run with -c 'lua dofile(...)', not -l: terminal input needs the main event loop.
local config = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(config)
vim.g.mapleader = " "
vim.o.hidden = true
vim.o.autoread = true
vim.o.swapfile = false

local root = vim.fn.tempname()
vim.fn.mkdir(root .. "/.git", "p")
local file = root .. "/example.txt"
local job
local finished = false

local function finish(err)
  if finished then
    return
  end
  finished = true
  if job then
    vim.fn.jobstop(job)
  end
  vim.fn.delete(root, "rf")
  if err then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
  else
    print("All live agent checks passed")
    vim.cmd("qa!")
  end
end

local function guarded(callback)
  return function()
    local ok, err = xpcall(callback, debug.traceback)
    if not ok then
      finish(err)
    end
  end
end

local function wait_for(predicate, label, callback)
  local started = vim.uv.hrtime()
  local function poll()
    if predicate() then
      callback()
    elseif (vim.uv.hrtime() - started) / 1e6 > 1200 then
      error(label)
    else
      vim.defer_fn(guarded(poll), 20)
    end
  end
  guarded(poll)()
end

guarded(function()
  require("config.keymaps")
  require("config.autocmds")
  local agent = require("config.agent")
  agent.setup()
  vim.fn.writefile({ "before" }, file)
  vim.cmd.edit(file)
  local code = vim.api.nvim_get_current_buf()
  agent.toggle({ "sh", "-c", "exec cat" })
  local terminal = vim.api.nvim_get_current_buf()
  job = vim.b.terminal_job_id

  vim.defer_fn(guarded(function()
    assert(vim.api.nvim_get_mode().mode == "t", "Test must run in actual terminal input mode")
    vim.fn.writefile({ "live agent change" }, file)
    wait_for(function()
      return vim.api.nvim_buf_get_lines(code, 0, -1, false)[1] == "live agent change"
    end, "Code must refresh promptly while terminal input remains active", function()
      assert(vim.api.nvim_get_mode().mode == "t", "Refresh must preserve terminal input mode")
      print("PASS: live terminal input refreshes code promptly without changing focus")
      vim.api.nvim_input(vim.keycode("<C-g>"))
      wait_for(function()
        return vim.fn.bufwinid(terminal) == -1
      end, "Ctrl-g must hide the agent from terminal input", function()
        assert(vim.fn.jobwait({ job }, 0)[1] == -1, "Hiding must keep the agent alive")
        vim.api.nvim_input(vim.keycode("<C-g>"))
        wait_for(function()
          return vim.api.nvim_get_current_buf() == terminal and vim.api.nvim_get_mode().mode == "t"
        end, "Ctrl-g from code must reopen the same agent and resume input", function()
          assert(vim.b.terminal_job_id == job, "Reopen must reuse the process")
          print("PASS: Ctrl-g hides and reopens the same live agent")
          finish()
        end)
      end)
    end)
  end), 50)
end)()

vim.defer_fn(function()
  finish("FAIL: live agent checks timed out")
end, 6000)
