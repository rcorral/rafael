Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Post extends Backbone.Model

    urlRoot: "#{sd.API_URL}/api/posts"

    frontEndUrl: -> "/blog/#{@id}"

    parse: (resp, options) ->
        resp.id = resp.slug unless resp.id
        resp.date = new Date resp.date
        resp

    toJSON: ->
        json = super
        json.postUrl = @frontEndUrl()
        json

    loadPost: (postID, options={}) ->
        @clear silent: true
        @set id: postID
        @fetch options
