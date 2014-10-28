_ = require 'underscore'
postLanguage = require './post-language.js'

module.exports.parse = postLanguage.parse

module.exports.encode = (post) ->
    post.date = post.date.toJSON() if _.isDate post.date
    post.tags = JSON.stringify post.tags if _.isArray post.tags
    post

module.exports.decode = (post) ->
    post.date = new Date post.date if post.date
    post.tags = JSON.parse post.tags if post.tags
    post
