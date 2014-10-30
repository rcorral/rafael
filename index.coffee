debug = require('debug')('server')
express = require 'express'
setup = require './lib/setup'

app = module.exports = express()
setup app

module.exports.init = ->
    # Start the server and send a message to IPC for the integration test
    # helper to hook into.
    app.listen process.env.NODE_PORT, ->
        debug "Listening on port #{process.env.NODE_PORT}"
        process.send? 'listening'

if module.parent
    module.exports = app
else
    module.exports.init()
