Mincer = require 'mincer'
path = require 'path'

Util =

    getAssets: (env) ->
        if env is 'development'
            console.log 'in dev'

        assets = 'app/assets'
        publicAssets = path.join __dirname, '../../public/assets'
        filenames = ['main.js', 'portfolio.css']

        Mincer.logger.use console
        environment = new Mincer.Environment path.join __dirname, '../../'
        environment.appendPath path.join assets, 'javascripts'
        environment.appendPath path.join assets, 'stylesheets'

        manifest = new Mincer.Manifest environment, publicAssets

        manifest.compile filenames, (err) ->
            if (err)
                console.error err
                process.exit 1

        console.log manifest.assets
        console.log manifest.files

    # Gets the path for a given component
    componentPath: (name) ->
        componentsFolder = '../../components'

        switch name
            when 'underscore' then componentPath = 'jashkenas-underscore/underscore'
            else return ''

        path.join componentsFolder, componentPath

module.exports = Util
