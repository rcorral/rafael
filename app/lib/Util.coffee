debugError = require('debug')('error')
Mincer = require 'mincer'
path = require 'path'

Util =

    getAssets: (env) ->
        # inDevelopment = env is 'development'
        assets = 'app/assets'
        publicAssets = path.join __dirname, '../../public/assets'
        filenames = ['app.js', 'app.css']

        Mincer.logger.use console
        environment = new Mincer.Environment path.join __dirname, '../../'
        environment.appendPath path.join assets, 'javascripts'
        environment.appendPath 'components'
        environment.appendPath path.join assets, 'stylesheets'

        manifest = new Mincer.Manifest environment, publicAssets
        manifest.compile filenames

        mappedAssets = js: [], css: []
        for absoluteName,asset of manifest.assets
            match = absoluteName.match /(js|css)$/
            mappedAssets[match[1]].push asset

        mappedAssets

    # Gets the path for a given component
    componentPath: (name) ->
        componentsFolder = '../../components'

        switch name
            when 'lodash' then componentPath = 'lodash-lodash/dist/lodash.compat'
            else return ''

        path.join componentsFolder, componentPath

module.exports = Util
