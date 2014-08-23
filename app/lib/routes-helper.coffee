Util = require '../lib/util'

_ = require Util.componentPath 'lodash'
fs = require 'fs'
jade = require 'jade'
path = require 'path'

routesHelper =

    getClientTemplates: (inDevelopment) ->
        projectsDir = path.join __dirname, '../views/client/projects'
        projectFiles = fs.readdirSync projectsDir
        templates = []

        _.each projectFiles, (file) ->
            templates.push jade.renderFile path.join(projectsDir, file),
                pretty: inDevelopment

        templates

module.exports = routesHelper
