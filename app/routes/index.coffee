express = require 'express'
routesHelper = require 'routes-helper'

class routes

    setup: (app) ->
        assets = app.get 'assets'
        env = app.get 'env'
        clientTemplates = routesHelper.getClientTemplates
            inDevelopment: env is 'development'
            assetHostsFn: app.get 'assetHostsFn'
        router = express.Router()
        proxyPort = app.get('proxyPort')|0
        port = app.get 'port'
        baseURL = "http://#{app.get('host')}#{if proxyPort isnt 80 then (':' + port) else ''}/"

        # GET home page.
        router.get /^\/(portfolio|about)?$/, (req, res) ->
            res.render 'index',
                assets: assets
                baseURL: baseURL
                config: JSON.stringify
                    environment: env
                description: 'Full stack engineer in San Francisco. Known language: JS, PHP, CSS, HTML, SQL, NoSQL'
                getHost: app.get 'assetHostsFn'
                inProduction: env is 'production'
                title: 'Rafael Corral'
                templates: clientTemplates

        # Finally set them up
        app.use '/', router

module.exports = new routes
