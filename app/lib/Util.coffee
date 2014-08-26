Mincer = require 'mincer'

fs = require 'fs'
path = require 'path'

Util =

    findFilesOfExtension: (directory, extension) ->
        _ = require Util.componentPath 'lodash'
        bucket = []
        files = fs.readdirSync directory
        regex = new RegExp "\.#{extension}$", 'i'

        for file in files
            absolutePath = path.join directory, file
            if fs.lstatSync(absolutePath).isDirectory()
                bucket.concat Util.findFilesOfExtension file, extension
            else if regex.test file
                bucket.push absolutePath
            else
                continue

        bucket

    deleteFilesInDirectory: (directory, opts={}) ->
        files = fs.readdirSync directory
        exclude = opts.exclude or []

        for file in files
            continue if file in exclude
            fs.unlinkSync path.join directory, file

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
