local moveWindowEvent
local isDragging = false
local draggedWindow = nil
local initialMousePos = nil
local initialWindowPos = nil
local lastMoveTime = 0
local throttleInterval = 0.1 -- 节流时间间隔，单位为秒
local log   = hs.logger.new('query', 'info')

-- 定义一个函数来打印表的内容
local function printTable(t)
  for key, value in pairs(t) do
      print(key, value)
  end
end

-- 创建一个函数用来检测是否按下了 Shift 键
local function isShiftPressed()
    return hs.eventtap.checkKeyboardModifiers().shift
end

-- 创建一个鼠标事件监听
moveWindowEvent = hs.eventtap.new({hs.eventtap.event.types.rightMouseDown, hs.eventtap.event.types.rightMouseUp, hs.eventtap.event.types.rightMouseDragged}, function(event)
    local eventType = event:getType()

    if eventType == hs.eventtap.event.types.rightMouseDown and isShiftPressed() then
        -- 按下鼠标右键时，记录窗口和鼠标的起始位置
        draggedWindow = hs.window.focusedWindow()
        initialMousePos = hs.mouse.absolutePosition()
        initialWindowPos = draggedWindow:frame()
        isDragging = true
        return true
    elseif eventType == hs.eventtap.event.types.rightMouseDragged and isDragging then
        -- 如果正在拖动窗口，根据鼠标移动更新窗口位置
        local currentTime = hs.timer.secondsSinceEpoch()
        if currentTime - lastMoveTime > throttleInterval then
            local currentMousePos = hs.mouse.absolutePosition()
            log.i('=====')
            local dx = currentMousePos.x - initialMousePos.x
            local dy = currentMousePos.y - initialMousePos.y
            draggedWindow:setFrame({
                x = initialWindowPos.x + dx,
                y = initialWindowPos.y + dy,
                w = initialWindowPos.w,
                h = initialWindowPos.h
            })
            return true
        end
    elseif eventType == hs.eventtap.event.types.rightMouseUp and isDragging then
        hs.alert.show("333!")
        -- 鼠标右键释放，停止拖动
        isDragging = false
        draggedWindow = nil
        initialMousePos = nil
        initialWindowPos = nil
        return true
    end

    return false -- 如果不是我们关心的事件，不处理
end)

-- 启动监听
moveWindowEvent:start()
