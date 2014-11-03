Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Post extends Backbone.Model

    url: -> "#{sd.API_URL}/api/posts/#{@id}"

    parse: (resp, options) ->
        resp.date = new Date resp.date
        resp
