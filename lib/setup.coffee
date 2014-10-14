#
# Sets up intial project settings, middleware, mounted apps, and
# global configuration such as overriding Backbone.sync and
# populating sharify data
#

Backbone = require 'backbone'
compression = require 'compression'
express = require 'express'
inDevelopment = process.env.NODE_ENV is 'development'
favicon = require 'serve-favicon'
fs = require 'fs'
livereload = require 'connect-livereload' if inDevelopment
logger = require 'morgan'
path = require 'path'
sharify = require 'sharify'

module.exports = (app) ->

    # Inject some configuration & constant data into sharify
    sd = sharify.data =
        environment: process.env.NODE_ENV
        host: process.env.NODE_HOST
        port: process.env.NODE_PORT
        cdnHosts: process.env.NODE_CDNHOSTS

    inProduction = sd.environment is 'production'

    # Settings
    app.enable 'trust proxy'
    app.enable 'case sensitive routing'
    app.enable 'view cache' if inProduction

    # #use
    app.use sharify
    app.use favicon path.join(__dirname, '../public/favicon.ico')
    app.use logger if inProduction then 'prod' else 'dev'
    app.use livereload port: process.env.NODE_LIVERELOAD_PORT if inDevelopment
    app.use compression threshold: 512

    # Test only
    if 'test' is sd.environment
        # Mount fake API server
        app.use '/__api', require('../test/helpers/integration.coffee').api

    # Mount apps
    app.use require '../apps/home'
    app.use require '../apps/portfolio'
    app.use require '../apps/about'

    # Mount static middleware for sub apps, components, and project-wide
    maxAge = 1000 * 60 * 60 * 24 * 365 # 1 year
    fs.readdirSync(path.resolve __dirname, '../apps').forEach (fld) ->
        app.use express.static(path.resolve(__dirname, "../apps/#{fld}/public"), {maxAge})
    fs.readdirSync(path.resolve __dirname, '../components').forEach (fld) ->
        app.use express.static(path.resolve(__dirname, "../components/#{fld}/public"), {maxAge})
    app.use express.static(path.resolve(__dirname, '../public'), {maxAge})

    app.use require './error-handler'
