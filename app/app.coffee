Util = require 'lib/util'

express = require 'express'
path = require 'path'
favicon = require 'static-favicon'
logger = require 'morgan'
routes = require './routes/index'

app = express()
environment = app.get 'env'

if environment is 'development'
    Util.deleteFilesInDirectory path.join(__dirname, '../public/assets'),
        exclude: ['index.html']

# Settings
app.enable 'trust proxy'
app.enable 'case sensitive routing'

# view engine setup
app.set 'views', path.join(__dirname, 'views', 'server')
app.set 'view engine', 'jade'
app.set 'assets', Util.getAssets(environment)
app.use favicon()
app.use logger 'dev'
app.use express.static(path.join(__dirname, '..', 'public'))
routes.setup app

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

module.exports = app
