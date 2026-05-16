local M = {}

M.mod = "SUPER"
M.browser = "zen"
M.term = "foot"
M.editor = "nvim"
M.default_layout = "scrolling"

M.workspaces_per_monitor = 10

function M.merge_orphaned_windows()
  local clients = hl.get_windows and hl.get_windows() or {}

  for _, client in ipairs(clients) do
    if client.workspace and client.workspace.id > 0 and client.monitor ~= nil then
      local ws_id = client.workspace.id
      local mon_id = client.monitor.id

      local expected_min = mon_id * M.workspaces_per_monitor + 1
      local expected_max = (mon_id + 1) * M.workspaces_per_monitor

      if ws_id < expected_min or ws_id > expected_max then
        local relative_ws = ((ws_id - 1) % M.workspaces_per_monitor) + 1
        local target_ws = mon_id * M.workspaces_per_monitor + relative_ws

        hl.dispatch(hl.dsp.window.move({
          window = client,
          workspace = target_ws,
        }))
      end
    end
  end
end

function M.init_split_workspaces(target_monitor)
  local monitors = target_monitor and { target_monitor } or (hl.get_monitors and hl.get_monitors() or {})
  if #monitors == 0 then return end

  local active_mon = hl.get_active_monitor()

  for _, mon in ipairs(monitors) do
    hl.dispatch(hl.dsp.focus({ monitor = mon.name }))
    hl.dispatch(hl.dsp.focus({ workspace = M.split_workspace(1) }))
  end

  if active_mon then
    hl.dispatch(hl.dsp.focus({ monitor = active_mon.name }))
  end
end

function M.split_workspace(n)
  local mon = hl.get_active_monitor()
  local monitor_id = mon and mon.id or 0
  return monitor_id * M.workspaces_per_monitor + n
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

function M.set_layout(layout)
  if layout == M.default_layout then
    hl.config({ general = { layout = M.default_layout } })
    hl.dispatch(hl.dsp.submap("reset"))
  else
    hl.config({ general = { layout = layout } })
    hl.dispatch(hl.dsp.submap(layout))
  end
  hl.exec_cmd('notify-send "Switched to ' .. layout .. ' layout"')
end

function M.key_table_parser(key_table, path, default_opts)
  path = path or {}
  for key, value in pairs(key_table) do
    local new_path = { table.unpack(path) }
    table.insert(new_path, key)
    if value.action then
      local opts = default_opts
      if value.opts then
        opts = {}
        for k, v in pairs(default_opts or {}) do opts[k] = v end
        for k, v in pairs(value.opts) do opts[k] = v end
      end
      hl.bind(table.concat(new_path, "+"), value.action, opts)
    else
      M.key_table_parser(value, new_path, default_opts)
    end
  end
end

function M.layout_table_submapper(layout_table, layout)
  if layout == M.default_layout then
    M.key_table_parser(layout_table[layout], {})
  else
    hl.define_submap(layout, function()
      M.key_table_parser(layout_table[layout], {})
    end)
  end
end

return M
