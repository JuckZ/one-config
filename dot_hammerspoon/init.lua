local utils = require("utils")
local shared = require("shared")
-- local stackline = require "stackline"
-- require("keyboard.yabai")
local moveModule = require("pro-move")
local reiszeModule = require("pro-resize")
-- require("keyboard.hyper")
-- require("keyboard.tmux")
-- require("vim-mode")
-- require("keyboard.system")

hs.hotkey.bind({shared.altMod,  "shift"}, "R", function()
  utils.reloader.reload()
end)

hs.hotkey.bind({shared.mainMod, shared.altMod, "ctrl"}, "W", function()
  utils.nativeNotice()
end)

hs.hotkey.bind({shared.mainMod, shared.altMod, "ctrl"}, "C", function()
  utils.toggleClock()
end)

utils.reloader.init()
-- moveModule.init()
reiszeModule.init()
-- stackline:init()