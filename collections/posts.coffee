Backbone = require 'backbone'
Post = require '../models/post.coffee'
sd = require('sharify').data

module.exports = class Posts extends Backbone.Collection

    POSTS_PER_PAGE: 10
    page: 0
    total: 0

    url: -> "#{sd.API_URL}/api/posts/page/#{@page}"

    urlForPage: (page) ->
        url = "/blog"
        url += "/page/#{page}" if page
        url

    model: Post

    initialize: (models, options) ->
        @page = options.page if options.page
        @total = options.total if options.total

    parse: (resp, options) ->
        @total = resp.total
        resp.posts

    loadPage: (page, options={}) ->
        @page = page
        @fetch options

    forTemplate: ->
        posts: @toJSON()
        sd: sd
        page: @page
        isFirstPage: @page is 0
        isLastPage: (@page + 1) is Math.ceil @total / @POSTS_PER_PAGE
        prevPageUrl: @urlForPage if @page - 1 < 0 then 0 else @page - 1
        nextPageUrl: @urlForPage @page + 1
