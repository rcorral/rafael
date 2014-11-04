appLocals = require 'app-locals'
jade = require 'jade'
path = require 'path'
Posts = require '../../collections/posts'
sd = require('sharify').data
template = require 'template-skeleton'

templatePath = path.join __dirname, 'templates'
appView = jade.compileFile "#{templatePath}/index.jade"

module.exports.init = (app) ->
    template.register app

module.exports.index = (req, res) ->
    page = parseInt req.params[0], 10
    page = 0 if isNaN page
    posts = new Posts null, page: page
    posts.fetch
        # cache: true
        success: ->
            res.locals.sd.blogPage = posts.page
            res.locals.sd.blogPosts = posts.toJSON()
            res.locals.sd.totalPosts = posts.total
            template.render req, res,
                appName: 'blog'
                appView: appView posts.forTemplate()
                navbarOpts:
                    blogActive: true
