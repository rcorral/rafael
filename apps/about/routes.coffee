appLocals = require 'app-locals'
express = require 'express'
jade = require 'jade'
path = require 'path'
template = require 'template-skeleton'

module.exports = (app) ->
    template.register app
    router = express.Router()
    appView = jade.renderFile path.join(__dirname, 'templates/index.jade'), appLocals

    router.get '/about', (req, res) ->
        template.render req, res,
            appName: 'about'
            appView: appView
            navbarOpts:
                aboutActive: true

    router
