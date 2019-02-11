local jwt = require('cpp.jwt')

local iyo_pub_key = [[-----BEGIN PUBLIC KEY-----
MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAES5X8XrfKdx9gYayFITc89wad4usrk0n2
7MjiGYvqalizeSWTHEpnd7oea9IQ8T5oJjMVH5cc0H5tFSKilFFeh//wngxIyny6
6+Vq5t5B0V0Ehy01+2ceEon2Y0XDkIKv
-----END PUBLIC KEY-----]]

local M = {}

function M.verify(conf, token)
    if not jwt.verify(token, iyo_pub_key) then
        return
    end

    jwt_obj = jwt.decode(token)

    if not jwt_obj then
        return
    end

    for _, scope in ipairs(jwt_obj.payload.scope) do
        if not string.find(scope, conf.scope) then
            return
        end
    end

    return jwt_obj
end

return M
