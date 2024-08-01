local database = {}

---@param name string
---@return boolean
function database:createCollectionIfNotExist(name)
    local path = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, path)

    if not collectionFile then
        local data = '[]'

        SaveResourceFile(bridge.name, path, data, #data)

        return true
    end

    return false
end

---@param name string
---@param data table
---@return table?
function database:insertDataToCollection(name, data)
    local path = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, path)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if collectionData then
            local _id

            repeat
                Wait(0)

                _id = bridge.random:string(bridge.config.database.idLength)
            until not bridge.database:getDataToCollection(name, {
                _id = _id
            })

            data._id = _id

            collectionData[#collectionData+1] = data

            local newCollectionData = json.encode(collectionData, { indent = true })

            SaveResourceFile(bridge.name, path, newCollectionData, #newCollectionData)

            return data
        else
            bridge.logger:error(bridge.locale('collectionDataNotFound', {
                name = name
            }))
        end
    else
        bridge.logger:error(bridge.locale('collectionFileNotFound', {
            name = name
        }))
    end
end

---@param name string
---@param query table
---@return boolean
function database:removeDataToCollection(name, query)
    local path = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, path)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if collectionData then
            local resultData = {}

            for key, value in pairs(collectionData) do
                local match = true

                bridge:surf(value, query, function (first, second)
                    if first ~= second then
                        match = false
                    end
                end)

                if not match then
                    resultData[#resultData+1] = value
                end
            end

            local newCollectionData = json.encode(resultData, { indent = true })

            SaveResourceFile(bridge.name, path, newCollectionData, #newCollectionData)

            return true
        else
            bridge.logger:error(bridge.locale('collectionDataNotFound', {
                name = name
            }))
        end
    else
        bridge.logger:error(bridge.locale('collectionFileNotFound', {
            name = name
        }))
    end

    return false
end

---@param name string
---@param query table
---@param update table
---@return boolean
function database:updateDataToCollection(name, query, update)
    local path = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, path)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if collectionData then
            for key, value in pairs(collectionData) do
                local match = true

                bridge:surf(value, query, function (first, second)
                    if first ~= second then
                        match = false
                    end
                end)

                if match then
                    collectionData[key] = bridge:surf(value, update, function (_, second, set)
                        set(second)
                    end)
                end
            end

            local newCollectionData = json.encode(collectionData, { indent = true })

            SaveResourceFile(bridge.name, path, newCollectionData, #newCollectionData)

            return true
        else
            bridge.logger:error(bridge.locale('collectionDataNotFound', {
                name = name
            }))
        end
    else
        bridge.logger:error(bridge.locale('collectionFileNotFound', {
            name = name
        }))
    end

    return false
end

---@param name string
---@param query table
---@return table?
function database:getDataToCollection(name, query)
    local path = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, path)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if collectionData then
            local resultData = {}

            for key, value in pairs(collectionData) do
                local match = true

                bridge:surf(value, query, function (first, second)
                    if first ~= second then
                        match = false
                    end
                end)

                if match then
                    resultData[#resultData+1] = value
                end
            end

            return resultData
        else
            bridge.logger:error(bridge.locale('collectionDataNotFound', {
                name = name
            }))
        end
    else
        bridge.logger:error(bridge.locale('collectionFileNotFound', {
            name = name
        }))
    end
end

---@param name string
---@return table?
function database:getAllDataToCollection(name)
    local path = ('collections/%s.json'):format(name)
    local collectionFile = LoadResourceFile(bridge.name, path)

    if collectionFile then
        local collectionData = json.decode(collectionFile)

        if collectionData then
            return collectionData
        else
            bridge.logger:error(bridge.locale('collectionDataNotFound', {
                name = name
            }))
        end
    else
        bridge.logger:error(bridge.locale('collectionFileNotFound', {
            name = name
        }))
    end
end

bridge.database = database
