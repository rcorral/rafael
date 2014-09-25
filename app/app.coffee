Util = require './lib/Util'

_ = require 'lodash'
debugError = require('debug')('error')
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
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
app.set 'host', process.env.NODE_HOST
app.set 'port', process.env.NODE_PORT
app.set 'proxyPort', process.env.NODE_PROXYPORT
app.set 'views', path.join(__dirname, 'views', 'server')
app.set 'view engine', 'jade'
app.set 'assets', Util.getAssets(environment)
app.use favicon(path.join(__dirname, '../public/favicon.ico'))
app.use logger 'dev'
app.use express.static(path.join(__dirname, '..', 'public'))

# Set assets hosts function
if process.env.NODE_CDNHOSTS
    assetHosts = process.env.NODE_CDNHOSTS.split ','
else
    assetHosts = [app.get 'host']
assetHosts = _.map assetHosts, (host) ->
    "//#{host}"
app.set 'assetHostsFn', Util.getAssetHostFn assetHosts

# Setup routes
routes.setup app

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

# error handlers
app.use (err, req, res, next) ->
    res.status err.status or 500
    debugError err
    res.render 'error',
        message: err.message
        error: {}

module.exports = app
