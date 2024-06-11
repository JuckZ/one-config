-- 模拟系统原生的功能键

-- 是否需要Fn按下
local withFn = true

-- cSpell:words eventtap

-- Map the hyper key to a key event
-- (cmd + ctrl + alt + shift + key)
-- @param key string the key to map
-- @param keyEvent string the key event to send
local function hyper(key, keyEvent)
	hs.hotkey.bind({ "fn", "F1", "alt", "shift" }, key, function()
		hs.eventtap.event.newKeyEvent(keyEvent, true):post()
	end)
end

hyper("f1", "display_brightness_decrement")
hyper("f2", "display_brightness_increment")
hyper("f3", "mission_control")
hyper("f4", "spotlight")
hyper("f5", "dictation")
hyper("f6", "f6")
hyper("f7", "rewind")
hyper("f8", "play_or_pause")
hyper("f9", "fast_forward")
hyper("f10", "mute")
hyper("f11", "volume_decrement")
hyper("f12", "volume_increment")

-- 使用 hyper 键定义快捷键，这里 hyper 通常是通过其他脚本定义的一个组合键
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- 调整屏幕亮度
hs.hotkey.bind(hyper, "f1", function() hs.brightness.down() end)
hs.hotkey.bind(hyper, "f2", function() hs.brightness.up() end)

-- 显示 Mission Control
hs.hotkey.bind(hyper, "f3", function() hs.execute("open -a 'Mission Control'") end)

-- 使用 Spotlight
hs.hotkey.bind(hyper, "f4", function() hs.spotlight.toggle() end)

-- 启用语音识别
hs.hotkey.bind(hyper, "f5", function() hs.execute("dictation start") end)

-- F6 保持原样
hs.hotkey.bind(hyper, "f6", function() end)

-- 媒体控制键
hs.hotkey.bind(hyper, "f7", function() hs.itunes.rewind() end)
hs.hotkey.bind(hyper, "f8", function() hs.itunes.playpause() end)
hs.hotkey.bind(hyper, "f9", function() hs.itunes.fastForward() end)

-- 静音
hs.hotkey.bind(hyper, "f10", function() hs.audiodevice.defaultOutputDevice():setMuted(not hs.audiodevice.defaultOutputDevice():muted()) end)

-- 音量控制
hs.hotkey.bind(hyper, "f11", function() hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.defaultOutputDevice():volume() - 5) end)
hs.hotkey.bind(hyper, "f12", function() hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.defaultOutputDevice():volume() + 5) end)


printTable = function(t)
  for key, value in pairs(t) do
    print(key, value)
  end
end

xyzzy = hs.hotkey.bind({}, "j",
    function()
        local test = hs.eventtap.checkKeyboardModifiers().fn
        print("======")
        -- printTable(test)
        print(test)
        print("======2")
        if hs.eventtap.checkKeyboardModifiers().fn then
            hs.alert.show("FN is DOWN!!!")
        else
          hs.alert.show("FN is UP!!!")
            xyzzy:disable()
            hs.eventtap.keyStroke({}, "j")
            xyzzy:enable()
        end
    end
)