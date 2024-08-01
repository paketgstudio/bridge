local player = {}

---@param sourceOrQuery number | table
---@return Player | Player[]
function player:find(sourceOrQuery)
    local result = {}
    local players
    local query = type(sourceOrQuery) == 'number' and {
        source = sourceOrQuery
    } or sourceOrQuery --[[@as table]]
    local transformedQuery = bridge:transform(query, bridge.schemas.player, bridge.framework.schemas.player)

    if bridge.framework.name == 'qb' then
        players = bridge.framework.Players
    end

    for key, value in pairs(players) do
        local match = true

        bridge:surf(value, transformedQuery, function (first, second)
            if first ~= second then
                match = false
            end
        end)

        if match then
            local transformedPlayer = bridge:transform(value, bridge.framework.schemas.player, bridge.schemas.player)

            result[#result+1] = transformedPlayer
        end
    end

    return #result == 1 and result[1] or result
end

bridge.player = player
