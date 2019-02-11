local session = require('resty.session').open()

local http_client = require('iyo-auth.http')

local M = {}

function M.set_cookie()
end

function M.authorization_url(conf, state)
    local params = {
        response_type = 'code',
        client_id = conf.organization,
        redirect_uri = conf.redirect_uri,
        scope = conf.scope,
        state = state
    }
    return conf.authorization_url..'?'..ngx.encode_args(params)
end

function M.request_token(conf, value, state)
    local params = {
        grant_type = 'authorization_code',
        code = value,
        state = state,
        client_id = conf.organization,
        client_secret = conf.secret,
        redirect_uri = conf.redirect_uri,
    }

    local url = conf.token_url..'?'..ngx.encode_args(params)
    return http_client.request_json(url, 'POST')
end

function M.request_jwt(conf, access_token)
    local params = {
        scope = conf.scope
    }

    local headers = {
        Authorization = 'token '..access_token
    }

    local url = conf.jwt_url..'?'..ngx.encode_args(params)
    return http_client.request(url, 'GET', headers)
end

return M
