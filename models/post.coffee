Backbone = require 'backbone'
moment = require 'moment'
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

        date = moment @get 'date'
        json.uiDate = yyyymmdd: date.format 'YYYY-MM-DD'
        if moment().diff(date, 'weeks') is 0
            json.uiDate.friendly = date.fromNow()
        else
            json.uiDate.friendly = date.format 'dddd, MMMM Do YYYY'
        json

    loadPost: (postID, options={}) ->
        @clear silent: true
        @set id: postID
        @fetch options
