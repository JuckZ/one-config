local testModule = require("test")
local proMove = require("pro-move")
-- stackline = require "stackline"
-- skhd = require("skhd")
-- wincent = require("wincent")

hs.loadSpoon("AClock")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  spoon.AClock:toggleShow()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  -- testModule.hsAlert()
  testModule.nativeNotice()
end)

-- stackline:init()