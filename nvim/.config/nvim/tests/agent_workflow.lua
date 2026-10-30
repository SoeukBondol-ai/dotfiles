-- Native-terminal integration checks; no plugins, credentials, or model calls.
local config = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(config)
vim.g.mapleader = " "
vim.o.hidden = true
vim.o.autoread = true
local root = vim.fn.tempname()
vim.fn.mkdir(root .. "/.git", "p")
local file = root .. "/example.txt"
local refresh = require("config.file_refresh")
local agent = require("config.agent")
local messages = {}
vim.notify = function(message)
  messages[#messages + 1] = message
end

local function contents(buf)
  return vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
end

local function wait_for(predicate, label)
  assert(vim.wait(4000, predicate, 20), label)
end

local ok, err = xpcall(function()
  require("config.autocmds")
  agent.setup()
  vim.fn.writefile({ "before" }, file)
  vim.cmd.edit(file)
  local code = vim.api.nvim_get_current_buf()
  local code_win = vim.api.nvim_get_current_win()
  vim.fn.writefile({ "after: changed by agent" }, file)
  vim.api.nvim_exec_autocmds("TermLeave", {})
  wait_for(function()
    return contents(code) == "after: changed by agent"
  end, "TermLeave must refresh code")
  print("PASS: leaving terminal refreshes external edits")

  vim.api.nvim_buf_set_lines(code, 0, -1, false, { "unsaved local work" })
  vim.fn.writefile({ "another external change" }, file)
  refresh.check()
  assert(contents(code) == "unsaved local work" and vim.bo[code].modified, "Unsaved work must survive")
  print("PASS: refresh preserves unsaved work")
  vim.bo[code].modified = false
  refresh.check()

  -- A real PTY process stands in for an interactive agent, without AI requests.
  agent.toggle({ "sh", "-c", "pwd; exec cat" })
  vim.cmd.stopinsert()
  local terminal = vim.api.nvim_get_current_buf()
  local job = vim.b[terminal].terminal_job_id
  wait_for(function()
    return table.concat(vim.api.nvim_buf_get_lines(terminal, 0, -1, false), "\n"):find(root, 1, true) ~= nil
  end, "Agent must start in the Git project root")
  assert(vim.b[terminal].agent_root == root)
  assert(vim.fn.jobwait({ job }, 0)[1] == -1)
  assert(vim.fn.maparg("<C-g>", "t", false, true).buffer == 1)

  -- No focus event: code must still update with the agent split focused.
  vim.fn.writefile({ "live background agent update" }, file)
  wait_for(function()
    return contents(code) == "live background agent update"
  end, "Timer must refresh code")
  print("PASS: background edits refresh while agent split is focused")

  agent.toggle()
  assert(vim.fn.bufwinid(terminal) == -1, "Toggle must hide the terminal")
  assert(vim.fn.jobwait({ job }, 0)[1] == -1, "Hiding must keep the process alive")
  agent.toggle()
  vim.cmd.stopinsert()
  assert(vim.api.nvim_get_current_buf() == terminal, "Reopen must reuse the terminal")
  vim.fn.chansend(job, "hello agent\n")
  wait_for(function()
    return table.concat(vim.api.nvim_buf_get_lines(terminal, 0, -1, false), "\n"):find("hello agent", 1, true) ~= nil
  end, "Reopened agent must accept input")
  vim.api.nvim_set_current_win(code_win)
  agent.toggle()
  vim.cmd.stopinsert()
  assert(vim.api.nvim_get_current_buf() == terminal, "Toggle from code must focus the existing agent")
  print("PASS: hide/reopen/focus reuses the live agent session")

  agent.toggle()
  local wins = #vim.api.nvim_list_wins()
  agent.toggle({ "nonexistent-agent-for-workflow-test" })
  assert(#vim.api.nvim_list_wins() == wins, "Missing command must not create a split")
  assert(messages[#messages]:find("executable not found", 1, true))
  print("PASS: missing CLI handled without creating a split")

  vim.fn.jobstop(job)
  wait_for(function()
    return vim.fn.jobwait({ job }, 0)[1] ~= -1
  end, "Test process must exit")
  agent.toggle()
  vim.cmd.stopinsert()
  assert(vim.api.nvim_get_current_buf() ~= terminal, "Exited hidden agent must restart")
  vim.fn.jobstop(vim.b.terminal_job_id)
  print("PASS: exited agent starts a new process")
end, debug.traceback)

vim.fn.delete(root, "rf")
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
print("All agent workflow checks passed")
vim.cmd("qa!")
