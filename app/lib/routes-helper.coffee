Util = require '../lib/Util'

_ = require 'lodash'
fs = require 'fs'
jade = require 'jade'
path = require 'path'

routesHelper =

    getClientTemplates: (options) ->
        templatesDir = path.join __dirname, '../views/client'
        templatePaths = Util.findFilesOfExtension templatesDir, 'jade'
        templates = []

        _.each templatePaths, (file) ->
            templates.push jade.renderFile file,
                pretty: options.inDevelopment
                getHost: options.assetHostsFn

        templates

module.exports = routesHelper
