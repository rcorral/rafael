sd = require('sharify').data

# #set assets hosts function
if sd.cdnHosts
    hosts = sd.cdnHosts.split ','
else
    hosts = [sd.host]

hosts = hosts.map (host) ->
    if sd.environment is 'development'
        "http://#{host}:#{sd.port}"
    else
        "//#{host}"

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
