# 
# Routes file that exports route handlers for ease of testing.
#

express = require 'express'
jade = require 'jade'
path = require 'path'
template = require 'template-skeleton'

module.exports = (app) ->
    template.register app
    router = express.Router()
    appView = jade.renderFile path.join __dirname, 'templates/index.jade'

    router.get '/', (req, res) ->
        template.render req, res,
            appName: 'home'
            appView: appView
            hasNav: false
            navbarOpts:
                homeActive: true

    router
