debugError = require('debug')('error')
express = require 'express'

app = module.exports = express()

app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

# error handlers
app.use (err, req, res, next) ->
    res.status err.status or 500
    debugError err
    if req.is 'json'
        res.send error: true, message: err.message
    else
        res.render 'error',
            message: err.message
            error: {}
