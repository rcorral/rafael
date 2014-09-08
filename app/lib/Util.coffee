Mincer = require 'mincer'

_ = require 'lodash'
fs = require 'fs'
path = require 'path'

Util =

    findFilesOfExtension: (directory, extension) ->
        bucket = []
        files = fs.readdirSync directory
        regex = new RegExp "\.#{extension}$", 'i'

        for file in files
            absolutePath = path.join directory, file
            if fs.lstatSync(absolutePath).isDirectory()
                filesInDir = Util.findFilesOfExtension path.join(directory, file), extension
                bucket = bucket.concat filesInDir
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
        assets = 'app/assets'
        publicAssets = path.join __dirname, '../../public/assets'
        filenames = ['app.js', 'app.css']

        Mincer.logger.use console
        environment = new Mincer.Environment path.join __dirname, '../../'
        environment.appendPath path.join assets, 'javascripts'
        environment.appendPath 'node_modules'
        environment.appendPath path.join assets, 'stylesheets'

        if env is 'production'
            environment.jsCompressor  = 'uglify'
            environment.cssCompressor = 'csso'
            environment = environment.index

        manifest = new Mincer.Manifest environment, publicAssets
        manifest.compile filenames

        mappedAssets = js: [], css: []
        for absoluteName,asset of manifest.assets
            match = absoluteName.match /(js|css)$/
            mappedAssets[match[1]].push asset

        mappedAssets

module.exports = Util
