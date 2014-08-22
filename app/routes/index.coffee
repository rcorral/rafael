express = require 'express'
fs = require 'fs'
path = require 'path'
Util = require '../lib/util'
_ = require Util.componentPath 'underscore'

router = express.Router()
projectsDir = path.join __dirname, '../assets/javascripts/views/projects'

projectFiles = fs.readdirSync projectsDir
_.each projectFiles, (file) ->
    console.log file

class routes

    setup: (app) ->
        # GET home page.
        router.get '/', (req, res) ->
            assets = app.get 'assets'
            res.render 'index',
                assets: assets
                title: 'Portfolio – Rafael Corral'

        # Finally set them up
        app.use '/', router

module.exports = new routes
