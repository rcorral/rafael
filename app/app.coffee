express = require 'express'
path = require 'path'
favicon = require 'static-favicon'
logger = require 'morgan'
routes = require './routes/index'
Util = require './lib/util'
app = express()

# Settings
app.enable 'trust proxy'
app.enable 'case sensitive routing'

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use favicon()
app.use logger 'dev'
app.use require('node-compass')(mode: 'expanded')
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

# error handlers
app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
        message: err.message
        error: {}

# Load assets
app.set 'assets', Util.getAssets app.get 'env'

module.exports = app