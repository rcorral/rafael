appLocals = require 'app-locals'
express = require 'express'
jade = require 'jade'
path = require 'path'
sharify = require 'sharify'
template = require 'template-skeleton'

module.exports = (app) ->
    template.register app
    router = express.Router()
    templatePath = path.join __dirname, 'templates'

    projectsFiles = [
        'stargazers.jade'
        'inspires.jade'
        'gotest.jade'
        'stagingdev.jade'
        'jommobile.jade'
        'jcache.jade'
        'xchat.jade'
        'ppw.jade'
        'socialmedia.jade'
        'salesforceintegrations.jade'
        'jomcdn.jade'
        'jomdefender.jade'
        'jphoto.jade'
        'wp4j.jade'
    ]
    projectTemplates = for file in projectsFiles
        jade.renderFile "#{templatePath}/#{file}", appLocals

    appView = jade.renderFile "#{templatePath}/index.jade",
        projects: projectTemplates

    router.get '/portfolio', (req, res) ->
        template.render req, res,
            appName: 'portfolio'
            appView: appView
            navbarOpts:
                portfolioActive: true

    router
