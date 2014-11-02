appLocals = require 'app-locals'
jade = require 'jade'
path = require 'path'
sharify = require 'sharify'
template = require 'template-skeleton'

templatePath = path.join __dirname, 'templates'
appView = jade.renderFile "#{templatePath}/index.jade",
    posts: {}

module.exports.init = (app) ->
    template.register app

module.exports.index = (req, res) ->
    template.render req, res,
        appName: 'blog'
        appView: appView
        navbarOpts:
            blogActive: true
