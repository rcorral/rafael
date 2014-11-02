appLocals = require 'app-locals'
express = require 'express'
jade = require 'jade'
path = require 'path'
sharify = require 'sharify'
template = require 'template-skeleton'

module.exports.init = (app) ->
    template.register app
    templatePath = path.join __dirname, 'templates'

    appView = jade.renderFile "#{templatePath}/index.jade",
        posts: {}

module.exports.index = (req, res) ->
    template.render req, res,
        appName: 'blog'
        appView: appView
        navbarOpts:
            blogActive: true
