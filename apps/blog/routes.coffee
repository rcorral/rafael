appLocals = require 'app-locals'
jade = require 'jade'
path = require 'path'
Post = require '../../models/post'
Posts = require '../../collections/posts'
sd = require('sharify').data
template = require 'template-skeleton'

templatePath = path.join __dirname, 'templates'
postsView = jade.compileFile "#{templatePath}/posts.jade"
postView = jade.compileFile "#{templatePath}/post.jade"

module.exports.init = (app) ->
    template.register app

module.exports.posts = (req, res) ->
    page = parseInt req.params[0], 10
    page = 0 if isNaN page
    posts = new Posts null, page: page
    posts.fetch
        cache: sd.ENV is 'production'
        success: ->
            res.locals.sd.blogPage = posts.page
            res.locals.sd.blogPosts = posts.toJSON()
            res.locals.sd.totalPosts = posts.total
            template.render req, res,
                appName: 'blog'
                appView: postsView posts.forTemplate()
                navbarOpts:
                    blogActive: true

module.exports.post = (req, res) ->
    post = new Post id: req.params.post
    post.fetch
        success: ->
            res.locals.sd.blogPost = post.toJSON()
            template.render req, res,
                appName: 'blogPost'
                appView: postView res.locals.sd.blogPost
                navbarOpts:
                    blogPostActive: true
