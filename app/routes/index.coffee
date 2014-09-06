express = require 'express'
routesHelper = require 'routes-helper'

class routes

    setup: (app) ->
        env = app.get 'env'
        assets = app.get 'assets'
        clientTemplates = routesHelper.getClientTemplates env is 'development'
        router = express.Router()
        proxyPort = app.get('proxyPort')|0
        port = app.get 'port'
        baseURL = "http://#{app.get('host')}#{if proxyPort isnt 80 then (':' + port) else ''}/"

        # GET home page.
        router.get /\/(portfolio)?/, (req, res) ->
            res.render 'index',
                assets: assets
                templates: clientTemplates
                baseURL: baseURL
                title: 'Rafael Corral – Software engineer in San Francisco'
                config: JSON.stringify
                    environment: env

        # Finally set them up
        app.use '/', router

module.exports = new routes
