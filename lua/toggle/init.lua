local M = {}

-- State to track the toggled window and current type
local toggle_state = {
  win = nil,
  type = nil
}

-- Cache for opened buffers
local open_bufs = {}

-- Internal toggle function
local function toggle_buf(conf)
  -- Check if window exists and is valid
  if toggle_state.win and vim.api.nvim_win_is_valid(toggle_state.win) then
    -- If same type, toggle off (hide)
    if conf.type == toggle_state.type then
      vim.api.nvim_win_hide(toggle_state.win)
      toggle_state.win = nil
      toggle_state.type = nil
      return
    end
  else
    -- Reset state if window became invalid
    toggle_state.win = nil
  end

  -- If no window tracked, get current window
  if toggle_state.win == nil then
    toggle_state.win = vim.api.nvim_get_current_win()
  end

  -- Update state type
  toggle_state.type = conf.type

  -- Check if buffer already exists for this type and is valid
  if open_bufs[conf.type] and vim.api.nvim_buf_is_valid(open_bufs[conf.type]) then
    vim.api.nvim_win_set_buf(toggle_state.win, open_bufs[conf.type])
    return
  end

  -- Create new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  open_bufs[conf.type] = buf
  vim.api.nvim_buf_set_option(buf, "filetype", conf.type)
  vim.api.nvim_buf_set_option(buf, "swapfile", false)

  vim.api.nvim_win_set_buf(toggle_state.win, open_bufs[conf.type])

  -- Run startup function if provided
  if conf.startup then
    conf.startup(toggle_state.win, open_bufs[conf.type])
  end
end

-- Setup function to apply keybinds
function M.setup(config)
  config = config or {}

  for _, conf in ipairs(config) do
    if conf.keybind then
      vim.keymap.set({ 'n', 'i', 't' }, conf.keybind, function() 
        toggle_buf(conf) 
      end, { desc = "Toggle " .. (conf.type or "Window") })
    end
  end
end

return M
