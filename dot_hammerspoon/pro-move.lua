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

local function startEventTap()
    if moveWindowEvent then
        moveWindowEvent:stop()
        moveWindowEvent = nil
    end

    moveWindowEvent = hs.eventtap.new({hs.eventtap.event.types.rightMouseDown, hs.eventtap.event.types.rightMouseUp, hs.eventtap.event.types.rightMouseDragged}, function(event)
        local eventType = event:getType()
        log.i('-=-=-=')
        if eventType == hs.eventtap.event.types.rightMouseDown and hs.eventtap.checkKeyboardModifiers().shift then
            draggedWindow = hs.window.focusedWindow()
            if draggedWindow then
                initialMousePos = hs.mouse.getAbsolutePosition()
                initialWindowPos = draggedWindow:frame()
                isDragging = true
                return true
            end
        elseif eventType == hs.eventtap.event.types.rightMouseDragged and isDragging then
            local currentTime = hs.timer.secondsSinceEpoch()
            if currentTime - lastMoveTime > throttleInterval then
                local currentMousePos = hs.mouse.getAbsolutePosition()
                local dx = currentMousePos.x - initialMousePos.x
                local dy = currentMousePos.y - initialMousePos.y

                draggedWindow:setFrame({
                    x = initialWindowPos.x + dx,
                    y = initialWindowPos.y + dy,
                    w = initialWindowPos.w,
                    h = initialWindowPos.h
                })
                lastMoveTime = currentTime
                return true
            end
        elseif eventType == hs.eventtap.event.types.rightMouseUp and isDragging then
            isDragging = false
            draggedWindow = nil
            initialMousePos = nil
            initialWindowPos = nil
            return true
        end

        return false
    end)

    moveWindowEvent:start()

    -- moveWindowEvent:stoppedCallback(function()
    --     hs.notify.new({title="EventTap Stopped", informativeText="EventTap has been restarted automatically."}):send()
    --     startEventTap()
    -- end)
end

startEventTap()

local checkTimer = hs.timer.new(5, function()
    if not moveWindowEvent:isEnabled() then
        hs.notify.new({title="EventTap Not Running", informativeText="Restarting EventTap"}):send()
        startEventTap()
    end
end)
checkTimer:start()
