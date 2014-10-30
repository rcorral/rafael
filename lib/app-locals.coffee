sd = require('sharify').data

# sd.cdnHosts comes from ENV variable
if sd.cdnHosts
    hosts = sd.cdnHosts.split ','
else
    hosts = [sd.host]

hosts = hosts.map (host) ->
    if sd.environment is 'development'
        "http://#{host}:#{sd.port}"
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
