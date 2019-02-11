local iyo_base_url = 'https://itsyou.online/v1/oauth'

local default_config = {
    organization = '',
    secret = '',
    authorization_url = iyo_base_url..'/authorize',
    token_url = iyo_base_url..'/access_token',
    jwt_url = iyo_base_url..'/jwt',
    redirect_uri = '/_oauth/callback'
}

local M = {}

function M.load()
    local config = {}

    for key, value in pairs(default_config) do
        local ngx_key = 'iyo_'..key
        if ngx.var[ngx_key] then
            config[key] = ngx.var[ngx_key]
        else
            config[key] = default_config[key]
        end
    end

    -- set the default scope (member of)
    config.scope = 'user:memberof:'..config.organization
    return config
end

return M
