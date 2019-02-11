local json = require('cjson')
local http = require('resty.http')

local M = {}

function M.request(url, method, headers, body)
    local client = http.new()
    -- FIXME: increase timeout or implement retries!
    client:set_timeout(1000)

    local res, err = client:request_uri(url, {
        method = method,
        body = body,
        headers = headers,
    })

    if not err then
        if res.status ~= ngx.HTTP_OK then
            ngx.exit(res.status)
        else
            return res.body
        end
    end
end

function M.request_json(url, method, headers, body)
    headers = headers or {}
    headers.Accept = 'application/json'

    local res = M.request(url, method, headers, body)
    if res then
        return json.decode(res)
    end
end

return M
