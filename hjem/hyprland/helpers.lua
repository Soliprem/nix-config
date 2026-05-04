local M = {}

M.mod = "SUPER"
M.browser = "zen"
M.term = "foot"
M.editor = "nvim"

M.workspaces_per_monitor = 10

function M.split_workspace(n)
  local mon = hl.get_active_monitor()
  local monitor_id = mon and mon.id or 0
  return monitor_id * M.workspaces_per_monitor + n
end

function M.bind(keys, dispatcher, flags)
  hl.bind(keys, dispatcher, flags)
end

function M.exec(keys, cmd, flags)
  hl.bind(keys, hl.dsp.exec_cmd(cmd), flags)
end

function M.focus_split_workspace(n)
  hl.dispatch(hl.dsp.focus({ workspace = M.split_workspace(n) }))
end

function M.move_to_split_workspace(n, follow)
  hl.dispatch(hl.dsp.window.move({
    workspace = M.split_workspace(n),
    follow = follow,
  }))
end

return M
