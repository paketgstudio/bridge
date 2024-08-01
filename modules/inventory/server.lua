local inventory = {}

---@param source integer
---@param name string
---@param count integer
---@return boolean
function inventory:addItem(source, name, count)
    print('addItem:', source, name, count)

    -- TODO

    return true
end

---@param source integer
---@param name string
---@param count integer
---@return boolean
function inventory:removeItem(source, name, count)
    print('removeItem:', source, name, count)

    -- TODO

    return true
end

---@param name string
---@param handler fun(source: integer, item: Item)
function inventory:createUsableItem(name, handler)
    if bridge.framework.name == 'qb' then
        bridge.framework.Functions.CreateUseableItem(name, handler)
    end
end

bridge.inventory = inventory
