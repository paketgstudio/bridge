local logger = {}

---@param ... unknown
function logger:inform(...)
    local transformedText = ('^5[INFORM]^7 %s'):format(table.concat({ ... }, ' '))

    print(transformedText)
end

---@param ... unknown
function logger:success(...)
    local transformedText = ('^2[SUCCESS]^7 %s'):format(table.concat({ ... }, ' '))

    print(transformedText)
end

---@param ... unknown
function logger:error(...)
    local transformedText = ('^1[ERROR]^7 %s'):format(table.concat({ ... }, ' '))

    print(transformedText)
end

return logger
