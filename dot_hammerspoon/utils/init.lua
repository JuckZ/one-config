local logModule = require("utils.log")
local reloaderModule = require("utils.auto-reload")

local M = {
  log = logModule,
  reloader = reloaderModule
}

function M.hsAlert()
  hs.alert.show("alert!")
end

function M.nativeNotice()
  hs.notify.new({
    title = "Hammerspoon",
    informativeText = "Hello World",
    soundName = hs.notify.defaultNotificationSound
  }):send()
end

hs.loadSpoon("AClock")

function M.toggleClock()
  spoon.AClock:toggleShow()
end

return M
