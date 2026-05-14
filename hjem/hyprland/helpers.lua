local M = {}

M.mod = "SUPER"
M.browser = "zen"
M.term = "foot"
M.editor = "nvim"
M.default_layout = "scrolling"

M.workspaces_per_monitor = 10

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
