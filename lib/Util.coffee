path = require 'path'

Util =

    # Gets the path for a given component
    componentPath: (name) ->
        componentsFolder = '../components'

        switch name
            when 'underscore' then componentPath = 'jashkenas-underscore/underscore'
            else return ''

        path.join componentsFolder, componentPath

module.exports = Util
