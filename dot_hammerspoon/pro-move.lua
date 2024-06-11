local moveWindowEvent -- 主监听器
local dragEvent -- 拖拽过程监听器
local isDragging = false
local draggedWindow = nil
local initialMousePos = nil
local initialWindowPos = nil
local lastMoveTime = 0
local throttleInterval = 0.05 -- 节流时间间隔，单位为秒

-- 清理拖拽状态
local function cleanupDrag()
    isDragging = false
    draggedWindow = nil
    initialMousePos = nil
    initialWindowPos = nil
end

-- 启动或停止拖拽事件监听器
local function manageDragEvent()
    if dragEvent then
        dragEvent:stop()
        dragEvent = nil
    end

    dragEvent = hs.eventtap.new({hs.eventtap.event.types.leftMouseDragged, hs.eventtap.event.types.leftMouseUp}, function(event)
        local eventType = event:getType()

        if eventType == hs.eventtap.event.types.leftMouseDragged and isDragging then
            local currentTime = hs.timer.secondsSinceEpoch()
            if currentTime - lastMoveTime > throttleInterval then
                local currentMousePos = hs.mouse.absolutePosition()
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
        elseif eventType == hs.eventtap.event.types.leftMouseUp and isDragging then
            -- 结束拖拽
            cleanupDrag()
            return true
        end

        return false
    end)
    dragEvent:start()
end

-- 监听鼠标按下事件
local function startEventTap()
    moveWindowEvent = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown}, function(event)
        local modifiers = event:getFlags()
        if modifiers.alt then
            draggedWindow = hs.window.focusedWindow()
            if draggedWindow then
                initialMousePos = hs.mouse.absolutePosition()
                initialWindowPos = draggedWindow:frame()
                isDragging = true
                manageDragEvent()
                return true
            end
        end
        return false
    end)
    moveWindowEvent:start()
end

return {
    init = startEventTap
}