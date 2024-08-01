local interface = {}

---@param text string
---@param type 'inform' | 'success' | 'error'
---@param duration number?
function interface:notification(text, type, duration)
    duration = duration or 3000

    if bridge.framework.name == 'qb' then
        local transformedType = 'inform' and 'primary' or type

        bridge.framework.Functions.Notify(text, transformedType, duration)
    end
end

bridge.interface = interface
