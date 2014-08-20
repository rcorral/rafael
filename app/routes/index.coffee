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

# GET home page.
router.get '/', (req, res) ->
    res.render 'index',
        title: 'Portfolio – Rafael Corral'

module.exports = router
