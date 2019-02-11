local session = require('resty.session').open()

local config = require('iyo-auth.config')
local jwt = require('iyo-auth.jwt')
local oauth = require('iyo-auth.oauth')
local nginx = require('iyo-auth.nginx')

local req_params = ngx.req.get_uri_args()
local state = session.data.iyo_state

if req_params.state ~= state then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local conf = config.load()
local result = oauth.request_token(conf, req_params.code, req_params.state)

if not result then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local token = result.access_token
local scope = result.scope
local info = result.info
local jwt_token = oauth.request_jwt(conf, token)

if jwt_token then
    local jwt_obj = jwt.verify(conf, jwt_token)
    if jwt_obj then
        local expires_in = jwt_obj.payload.exp - ngx.time()
        nginx.set_response_cookie('iyo_jwt', jwt_token, expires_in)
        -- TODO: define a config for success url or
        -- store the origin in cookies?
        ngx.redirect('/')
    else
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
else
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end
