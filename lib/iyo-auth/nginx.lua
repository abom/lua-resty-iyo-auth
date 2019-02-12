local M = {}

function M.get_req_jwt()
    local iyo_jwt = ngx.var.cookie_iyo_jwt;
    if not iyo_jwt then
        local auth_header = ngx.req.get_headers().Authorization
        if auth_header then
            auth_header = string.lower(auth_header)
            if string.find(auth_header, 'bearer') then
                iyo_jwt = string.sub(auth_header, 8, -1)
            end
        end
    end
    return iyo_jwt
end

function M.set_response_cookie(name, value, expires_in)
    if not expires_in then
        expires_in = 0
    end

    local cookie = name..'='..value..'; Path=/; HttpOnly; Max-Age='..expires_in
    ngx.header['Set-Cookie'] = cookie
end

return M
