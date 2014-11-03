Backbone = require 'backbone'
Post = require '../models/post.coffee'
sd = require('sharify').data

module.exports = class Posts extends Backbone.Collection

    url: -> "#{sd.API_URL}/api/posts/page/#{@page}"

    model: Post

    initialize: (models, options) ->
        @page = options.page or 0

    forTemplate: ->
        posts: @toJSON()
        sd: sd
        page: @page
