-- Auto reload Hammerspoon config
local function reload()
	hs.reload()
  hs.notify.new({ title = "Hammerspoon", informativeText = "Reload finished!" }):send()
end

return {
  init = function()
    hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/**/*", reload):start()
  end,
  reload = reload,
}