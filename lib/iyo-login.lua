local session = require('resty.session').open()
local uuid = require('resty.jit-uuid')

local config = require('iyo-auth.config')
local jwt = require('iyo-auth.jwt')
local oauth = require('iyo-auth.oauth')
local nginx = require('iyo-auth.nginx')

uuid.seed()

conf = config.load()
local token = nginx.get_req_jwt()

if token then
    if jwt.verify(conf, token) then
        ngx.exit(ngx.OK)
    else
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
else
    local state = uuid.generate_v4()
    session.data.iyo_state = state
    session:save()
    return ngx.redirect(oauth.authorization_url(conf, state))
end
