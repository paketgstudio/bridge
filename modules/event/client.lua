local event = {}

---@param name string
---@param handler fun(...: unknown?): unknown?
function event:register(name, handler)
    local transformedName = ('%s:event:%s'):format(bridge.name, name)

    RegisterNetEvent(transformedName, function (callback, ...)
        local stack = { pcall(handler, ...) }

        if stack[1] then
            table.remove(stack, 1)

            if callback then
                callback(table.unpack(stack))
            else
                TriggerServerEvent(transformedName, table.unpack(stack))
            end
        end
    end)
end

---@param name string
---@param ... unknown
---@return unknown
function event:trigger(name, ...)
    local promise = promise:new()

    local transformedName = ('%s:event:%s'):format(bridge.name, name)

    local function callback(...)
        promise:resolve({ ... })
    end

    TriggerEvent(transformedName, callback, ...)

    return table.unpack(Citizen.Await(promise))
end

---@param name string
---@param ... unknown
---@return unknown
function event:triggerServer(name, ...)
    local promise = promise:new()

    local transformedName = ('%s:event:%s'):format(bridge.name, name)

    local function callback(...)
        promise:resolve({ ... })
    end

    RegisterNetEvent(transformedName, callback)

    TriggerServerEvent(transformedName, nil, ...)

    return table.unpack(Citizen.Await(promise))
end

bridge.event = event
