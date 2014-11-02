appLocals = require 'app-locals'
jade = require 'jade'
path = require 'path'
template = require 'template-skeleton'

appView = jade.renderFile path.join(__dirname, 'templates/index.jade'), appLocals

module.exports.init = (app) ->
    template.register app

module.exports.index = (req, res) ->
    template.render req, res,
        appName: 'about'
        appView: appView
        navbarOpts:
            aboutActive: true
