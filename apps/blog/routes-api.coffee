_ = require 'underscore'
parser = require './lib/post-parser'
redis = require 'redis'
Util = require '../../components/Util'

module.exports.posts = (req, res, next) ->
    @config ?= require './config/redis.json'
    client = redis.createClient()
    POSTS_PER_PAGE = 10
    fields = ['title', 'date', 'tags', 'abstract']

    client.on 'connect', =>
        start = req.params.page * POSTS_PER_PAGE
        stop = start + POSTS_PER_PAGE
        client.zrange [@config.postorderKey, start, stop], (err, postKeys) =>
            throw 'DB error' if err

            posts = []
            getPost = (postKey, next) =>
                args = _.clone fields
                args.unshift "#{@config.postKey}:#{postKey}"
                client.hmget args, (err, postValues) ->
                    throw 'DB error' if err
                    post = parser.decode _.object fields, postValues
                    posts.push post
                    next()

            Util.syncLoop postKeys, getPost, ->
                client.end()
                res.send posts
