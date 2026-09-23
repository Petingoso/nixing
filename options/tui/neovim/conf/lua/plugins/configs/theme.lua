local theme_path = vim.fn.stdpath("config") .. "/lua/theme.lua"

local function load_theme()
  dofile(theme_path)
end

-- initial load
load_theme()

-- reload on SIGUSR1
local signal = vim.uv.new_signal()
signal:start(
  "sigusr1",
  vim.schedule_wrap(load_theme)
)

