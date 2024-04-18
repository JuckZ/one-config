-- Define a function to execute yabai commands
local function yabaiCommand(command)
  hs.execute('/usr/local/bin/yabai ' .. command, true)
end

-- Space Navigation with lalt - {1, 2, 3, 4}
hs.hotkey.bind({"alt"}, "1", function()
  yabaiCommand('-m space --focus 1')
end)

hs.hotkey.bind({"alt"}, "2", function()
  yabaiCommand('-m space --focus 2')
end)

hs.hotkey.bind({"alt"}, "3", function()
  yabaiCommand('-m space --focus 3')
end)

hs.hotkey.bind({"alt"}, "4", function()
  yabaiCommand('-m space --focus 4')
end)

-- Window Navigation with lalt - {h, j, k, l}
hs.hotkey.bind({"alt"}, "h", function()
  yabaiCommand('-m window --focus west')
end)

hs.hotkey.bind({"alt"}, "j", function()
  yabaiCommand('-m window --focus south')
end)

hs.hotkey.bind({"alt"}, "k", function()
  yabaiCommand('-m window --focus north')
end)

hs.hotkey.bind({"alt"}, "l", function()
  yabaiCommand('-m window --focus east')
end)

-- Toggle float and fullscreen states with lalt
hs.hotkey.bind({"alt"}, "space", function()
  yabaiCommand('-m window --toggle float')
end)

hs.hotkey.bind({"shift", "alt"}, "f", function()
  yabaiCommand('-m window --toggle zoom-fullscreen')
end)

-- Move windows between spaces with shift + lalt - {1, 2, 3, 4}
hs.hotkey.bind({"shift", "alt"}, "1", function()
  yabaiCommand('-m window --space 1')
end)

hs.hotkey.bind({"shift", "alt"}, "2", function()
  yabaiCommand('-m window --space 2')
end)

hs.hotkey.bind({"shift", "alt"}, "3", function()
  yabaiCommand('-m window --space 3')
end)

hs.hotkey.bind({"shift", "alt"}, "4", function()
  yabaiCommand('-m window --space 4')
end)

-- Additional key bindings can be added following the same pattern.
