Util = require '../lib/util'

_ = require Util.componentPath 'lodash'
fs = require 'fs'
jade = require 'jade'
path = require 'path'

routesHelper =

    getClientTemplates: (inDevelopment) ->
        projectsDir = path.join __dirname, '../views/client/projects'
        templatePaths = Util.findFilesOfExtension projectsDir, 'jade'
        templates = []

        _.each templatePaths, (file) ->
            templates.push jade.renderFile file,
                pretty: inDevelopment

        templates

module.exports = routesHelper
