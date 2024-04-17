local M = {}

function M.hsAlert()
  -- print("Hello")
  hs.alert.show("move!")
end

function M.nativeNotice()
  -- TODO not working
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end

return M
