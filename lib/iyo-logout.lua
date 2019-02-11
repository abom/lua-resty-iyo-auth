local session = require('resty.session').open()
local nginx = require('iyo-auth.nginx')

session:destroy()
nginx.set_response_cookie('iyo_jwt', '')

-- TODO: configure this url
ngx.redirect('/')
