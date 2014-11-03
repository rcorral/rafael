appLocals = require 'app-locals'
jade = require 'jade'
path = require 'path'
template = require 'template-skeleton'

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

module.exports.init = (app) ->
    template.register app

module.exports.index = (req, res) ->
    template.render req, res,
        appName: 'portfolio'
        appView: appView
        navbarOpts:
            portfolioActive: true
