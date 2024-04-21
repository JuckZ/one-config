-- cSpell:words koekeishiya yabai fullscreen unfloat hjkl
--
-- ██╗   ██╗ █████╗ ██████╗  █████╗ ██╗
-- ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║
--  ╚████╔╝ ███████║██████╔╝███████║██║
--   ╚██╔╝  ██╔══██║██╔══██╗██╔══██║██║
--    ██║   ██║  ██║██████╔╝██║  ██║██║
--    ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝
--
-- https://github.com/koekeishiya/yabai

local function yabai(commands)
	for _, cmd in ipairs(commands) do
		os.execute("/usr/local/bin/yabai -m " .. cmd)
	end
end

local function alt(key, commands)
	hs.hotkey.bind({ "alt" }, key, function()
		yabai(commands)
	end)
end

local function altShift(key, commands)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands)
	end)
end

local function altShiftNumber(number)
	altShift(number, { "window --space " .. number, "space --focus " .. number })
end

-- alpha
alt("l", { "space --focus recent" })
alt("m", { "space --toggle mission-control" })
alt("p", { "window --toggle pip" })
alt("g", { "space --toggle padding", "space --toggle gap" })
alt("r", { "space --rotate 90" })
alt("space", { "window --toggle float", "window --grid 4:4:1:1:2:2" })
-- alt("f", { "window --toggle zoom-fullscreen" })
altShift("f", { "window --toggle zoom-fullscreen" })

-- special characters
alt("'", { "space --layout stack" })
alt(";", { "space --layout bsp" })
alt("tab", { "space --focus recent" })

for i = 1, 9 do
	local num = tostring(i)
	alt(num, { "space --focus " .. num })
	altShiftNumber(num)
end

-- NOTE: use as arrow keys
local homeRow = { h = "west", j = "south", k = "north", l = "east" }

for key, direction in pairs(homeRow) do
	alt(key, { "window --focus " .. direction })
	altShift(key, { "window --swap " .. direction })
end