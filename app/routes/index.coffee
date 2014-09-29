express = require 'express'
routesHelper = require 'routes-helper'

class routes

    setup: (app) ->
        env = app.get 'env'
        assets = app.get 'assets'
        clientTemplates = routesHelper.getClientTemplates
            inDevelopment: env is 'development'
            assetHostsFn: app.get 'assetHostsFn'
        router = express.Router()
        proxyPort = app.get('proxyPort')|0
        port = app.get 'port'
        baseURL = "http://#{app.get('host')}#{if proxyPort isnt 80 then (':' + port) else ''}/"

        # GET home page.
        router.get /^\/(portfolio)?$/, (req, res) ->
            res.set 'Access-Control-Allow-Origin', 'http://cdn5.rafaelcorral.com'
            res.render 'index',
                assets: assets
                templates: clientTemplates
                baseURL: baseURL
                title: 'Rafael Corral'
                description: 'Full stack engineer in San Francisco. Known language: JS, PHP, CSS, HTML, SQL, NoSQL'
                config: JSON.stringify
                    environment: env
                getHost: app.get 'assetHostsFn'

        # Finally set them up
        app.use '/', router

module.exports = new routes
