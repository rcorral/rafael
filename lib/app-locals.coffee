sd = require('sharify').data

# sd.CDN_HOSTS comes from ENV variable
if sd.CDN_HOSTS
    hosts = sd.CDN_HOSTS.split ','
else
    hosts = [sd.HOST]

hosts = hosts.map (host) ->
    if sd.ENV is 'development'
        "http://#{host}:#{sd.PORT}"
    else
        "//#{host}"

# Closure that returns a function
# This function loops through available CDN hosts
# returning a new one with each call
assetHostsFn = do (hosts=hosts) ->
    if hosts.length is 1
      -> hosts[0]
    else
        counter = -1
        ->
            counter++
            counter = 0 if counter is hosts.length
            hosts[counter]

module.exports =
    getHost: assetHostsFn
