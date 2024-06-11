local resizeWindowEvent -- 主监听器
local resizeEvent -- resize过程监听器
local isResizing = false
local resizedWindow = nil
local initialMousePos = nil
local initialWindowPos = nil
local lastResizeTime = 0
local throttleInterval = 0.05 -- 节流时间间隔，单位为秒

-- 清理resize状态
local function cleanupDrag()
    isResizing = false
    resizedWindow = nil
    initialMousePos = nil
    initialWindowPos = nil
end

-- 启动或停止resize事件监听器
local function manageDragEvent()
    if resizeEvent then
        resizeEvent:stop()
        resizeEvent = nil
    end

    resizeEvent = hs.eventtap.new({hs.eventtap.event.types.rightMouseDragged, hs.eventtap.event.types.rightMouseUp}, function(event)
        local eventType = event:getType()

        if eventType == hs.eventtap.event.types.rightMouseDragged and isResizing then
            local currentTime = hs.timer.secondsSinceEpoch()
            if currentTime - lastResizeTime > throttleInterval then
                local currentMousePos = hs.mouse.absolutePosition()
                local dx = currentMousePos.x - initialMousePos.x
                local dy = currentMousePos.y - initialMousePos.y

                resizedWindow:setFrame({
                    x = initialWindowPos.x,
                    y = initialWindowPos.y,
                    w = initialWindowPos.w + dx,
                    h = initialWindowPos.h + dy
                })
                lastResizeTime = currentTime
                return true
            end
        elseif eventType == hs.eventtap.event.types.rightMouseUp and isResizing then
            -- 结束拖拽
            cleanupDrag()
            return true
        end

        return false
    end)
    resizeEvent:start()
end

-- 监听鼠标按下事件(去掉local 避免垃圾回收)
function startEventTap()
    resizeWindowEvent = hs.eventtap.new({hs.eventtap.event.types.rightMouseDown}, function(event)
        local modifiers = event:getFlags()
        if modifiers.alt then
            resizedWindow = hs.window.focusedWindow()
            if resizedWindow then
                initialMousePos = hs.mouse.absolutePosition()
                initialWindowPos = resizedWindow:frame()
                isResizing = true
                manageDragEvent()
                return true
            end
        end
        return false
    end)
    resizeWindowEvent:start()
end

return {
    init = startEventTap
}