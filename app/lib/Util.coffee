debugError = require('debug')('error')
Mincer = require 'mincer'
path = require 'path'

Util =

    getAssets: (env) ->
        if env is 'development'
            console.log 'in dev'

        assets = 'app/assets'
        publicAssets = path.join __dirname, '../../public/assets'
        filenames = ['app.js', 'app.css']

        Mincer.logger.use console
        environment = new Mincer.Environment path.join __dirname, '../../'
        environment.appendPath path.join assets, 'javascripts'
        environment.appendPath 'components'
        environment.appendPath path.join assets, 'stylesheets'

        manifest = new Mincer.Manifest environment, publicAssets

        manifest.compile filenames, (err) ->
            return unless err
            debugError err
            process.exit 1

        mappedAssets = {js: [], css: []}
        for absoluteName,asset of manifest.assets
            match = absoluteName.match /(js|css)$/
            mappedAssets[match[1]].push asset

        mappedAssets

    # Gets the path for a given component
    componentPath: (name) ->
        componentsFolder = '../../components'

        switch name
            when 'underscore' then componentPath = 'jashkenas-underscore/underscore'
            else return ''

        path.join componentsFolder, componentPath

module.exports = Util
