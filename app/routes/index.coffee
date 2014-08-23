express = require 'express'
routesHelper = require 'routes-helper'

class routes

    setup: (app) ->

        clientTemplates = routesHelper.getClientTemplates app.get('env') is 'development'
        router = express.Router()

        # GET home page.
        router.get '/', (req, res) ->
            assets = app.get 'assets'
            res.render 'index',
                assets: assets
                templates: clientTemplates
                title: 'Portfolio – Rafael Corral'

        # Finally set them up
        app.use '/', router

module.exports = new routes
