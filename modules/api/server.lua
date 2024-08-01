local api = {}

---@param url string
---@param method? 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE' | 'HEAD' | 'OPTIONS'
---@return number, unknown?
function api:request(url, method)
    local promise = promise:new()

    PerformHttpRequest(url, function (statusCode, response)
        promise:resolve({ statusCode, response })
    end, method or 'GET')

    return table.unpack(Citizen.Await(promise))
end

bridge.api = api
