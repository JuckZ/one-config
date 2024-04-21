local utils = require("utils")
local reloader = require("utils.auto-reload")
-- local stackline = require "stackline"
require("keyboard.yabai")
require("pro-move")
-- require("keyboard.hyper")
-- require("keyboard.tmux")
-- require("vim-mode")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  utils.toggleClock()
end)

hs.hotkey.bind({"cmd",  "alt", "ctrl"}, "R", function()
  reloader.reload()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  -- utils.hsAlert()
  utils.nativeNotice()
end)

reloader.init()
-- stackline:init()