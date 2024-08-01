local random = {}

random.charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

---@param length integer
---@return string
function random:string(length)
    local result = ''

    for i = 1, length do
        local index = math.random(1, #random.charset)

        result = ('%s%s'):format(result, random.charset:sub(index, index))
    end

    return result
end

---@param length integer
---@return integer
function random:integer(length)
    local result = ''

    for i = 1, length do
        local digit = math.random(0, 9)

        if i == 1 and digit == 0 then
            digit = math.random(1, 9)
        end

        result = result .. digit
    end

    return tonumber(result) --[[@as integer]]
end

bridge.random = random
