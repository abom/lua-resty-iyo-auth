# lua-resty-iyo-auth
[itsyou.online](https://itsyou.online) authentication for resty, based on [ngx-oauth2](https://github.com/jirutka/ngx-oauth) (code is simplified/rewritten and [cppjwt](https://github.com/abom/lua-cpp-jwt) is used instead).

### Installation
Using luarocks:

`luarocks install lua-resty-iyo-auth`

This will give you the path where files are installed (should be used in [nginx.conf](#Usage)), like:

`lua-resty-iyo-auth 0.0-1 is now installed in /sandbox/openresty/luarocks`

### Usage and configuration
A sample nginx.conf file with possible $iyo_* config variables can be found [here](conf/nginx.example.conf):

```conf
events {
    worker_connections 128;
}

error_log log/error.log;


http {
    # ipv6=off if resolving them is not supported
    resolver 8.8.8.8 4.2.2.2 ipv6=off;
    resolver_timeout 5s;

    # must be provided
    lua_ssl_trusted_certificate '/etc/ssl/certs/ca-certificates.crt';
    lua_ssl_verify_depth 2;

    # for development
    lua_package_path '/path/to/lua-resty-iyo-auth/?.lua;;';

    server {
        listen 8080;
        listen [::]:8080;

        # lua-resty-sesion config
        set $session_secret '<session_strong_secret>';

        # iyo config
        set $iyo_organization '<organization_name/client id>';
        set $iyo_secret '<itsyou.online client secret>';
        set $iyo_redirect_uri 'http://localhost:8080/_iyo/callback';
        # other possible configs
        # set $iyo_authorization_url 'https://itsyou.online/v1/oauth/auth...
        # set $iyo_token_url 'https://itsyou.online/v1/oauth/tok...
        # set $iyo_jwt_url 'https://itsyou.online/v1/oauth/jwt...

        location / {
            access_by_lua_file '/path/to/lua-resty-iyo-auth/iyo-login.lua';
            content_by_lua 'ngx.say("Done...!")';
        }

        location /_iyo/callback {
            resolver 8.8.8.8;
            content_by_lua_file '/path/to/lua-resty-iyo-auth/iyo-callback.lua';
        }

        location /_iyo/logout {
            content_by_lua_file '/path/to/lua-resty-iyo-auth/iyo-logout.lua';
        }

    }
}
```
