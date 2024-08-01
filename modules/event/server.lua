local event = {}

---@param name string
---@param handler fun(...: unknown?): unknown?
function event:register(name, handler)
    local transformedName = ('%s:event:%s'):format(bridge.name, name)

    RegisterNetEvent(transformedName, function (callback, ...)
        if callback then
            local stack = { pcall(handler, ...) }

            if stack[1] then
                table.remove(stack, 1)

                callback(table.unpack(stack))
            end
        else
            local stack = { pcall(handler, source, ...) }

            if stack[1] then
                table.remove(stack, 1)

                TriggerClientEvent(transformedName, source, table.unpack(stack))
            end
        end
    end)
end

---@param name string
---@param ... unknown
---@return unknown
function event:trigger(name, ...)
    local promise = promise:new()

    local function callback(...)
        promise:resolve({ ... })
    end

    local transformedName = ('%s:event:%s'):format(bridge.name, name)

    TriggerEvent(transformedName, callback, ...)

    return table.unpack(Citizen.Await(promise))
end

---@param name string
---@param source number
---@param ... unknown
---@return unknown
function event:triggerClient(name, source, ...)
    local promise = promise:new()

    local transformedName = ('%s:event:%s'):format(bridge.name, name)

    local function callback(...)
        promise:resolve({ ... })
    end

    RegisterNetEvent(transformedName, callback)

    TriggerClientEvent(transformedName, source, nil, ...)

    return table.unpack(Citizen.Await(promise))
end

bridge.event = event
