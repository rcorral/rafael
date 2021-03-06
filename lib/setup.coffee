#
# Sets up intial project settings, middleware, mounted apps, and
# global configuration such as overriding Backbone.sync and
# populating sharify data
#

Backbone = require 'backbone'
backboneCacheSync = require 'backbone-cache-sync'
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
        ENV: process.env.NODE_ENV
        HOST: process.env.NODE_HOST
        PORT: process.env.NODE_PORT
        CDN_HOSTS: process.env.NODE_CDNHOSTS
    proxyPort = process.env.NODE_PROXYPORT|0
    port = if proxyPort isnt 80 then (':' + sd.PORT) else ''
    sd.API_URL = "http://#{sd.HOST}#{port}"
    sd.APP_URL = "http://#{sd.HOST}#{port}"

    inProduction = sd.ENV is 'production'

    # Override Backbone to use server-side sync
    # add redis caching, and augment sync with Q promises.
    Backbone.sync = require 'backbone-super-sync'
    backboneCacheSync Backbone.sync, null, null, 'development'

    # Settings
    app.enable 'trust proxy', 'loopback' if inProduction
    app.enable 'case sensitive routing'
    app.enable 'view cache' if inProduction

    # #use
    app.use sharify
    app.use favicon path.join(__dirname, '../public/favicon.ico')
    app.use logger if inProduction then 'prod' else 'dev'
    app.use livereload port: process.env.NODE_LIVERELOAD_PORT if inDevelopment
    app.use compression threshold: 512 if inProduction

    # Mount apps
    app.use require '../apps/home'
    app.use require '../apps/portfolio'
    app.use require '../apps/about'
    app.use require '../apps/blog'

    # Mount static middleware for sub apps, components, and project-wide
    maxAge = 1000 * 60 * 60 * 24 * 365 # 1 year
    fs.readdirSync(path.resolve __dirname, '../apps').forEach (fld) ->
        app.use express.static(path.resolve(__dirname, "../apps/#{fld}/public"), {maxAge})
    # There's no components with public folders atm
    # fs.readdirSync(path.resolve __dirname, '../components').forEach (fld) ->
        # app.use express.static(path.resolve(__dirname, "../components/#{fld}/public"), {maxAge})
    app.use express.static(path.resolve(__dirname, '../public'), {maxAge})

    app.use require './error-handler'
