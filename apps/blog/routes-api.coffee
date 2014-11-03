_ = require 'underscore'
jade = require 'jade'
parser = require './lib/post-parser'
redis = require 'redis'
Util = require '../../components/Util'

module.exports.posts = (req, res) ->
    @config ?= require './config/redis.json'
    client = redis.createClient()
    POSTS_PER_PAGE = 10
    fields = ['title', 'slug', 'date', 'tags', 'abstract']

    client.on 'connect', =>
        start = req.params.page * POSTS_PER_PAGE
        stop = start + POSTS_PER_PAGE - 1
        client.zrange [@config.postorderKey, start, stop], (err, postKeys) =>
            throw 'DB error' if err

            posts = []
            getPost = (postKey, next) =>
                args = _.clone fields
                args.unshift "#{@config.postKey}:#{postKey}"
                client.hmget args, (err, postValues) ->
                    throw 'DB error' if err
                    post = parser.decode _.object fields, postValues
                    post.abstract = jade.render post.abstract
                    posts.push post
                    next()

            Util.syncLoop postKeys, getPost, ->
                client.end()
                res.send posts

module.exports.post = (req, res) ->
    @config ?= require './config/redis.json'
    client = redis.createClient()

    if req.params.post isnt req.params.post.replace /[^a-z0-9\-]/, ''
        return res.send {}

    client.on 'connect', =>
        key = "#{@config.postKey}:#{req.params.post}"
        client.hgetall key, (err, post) ->
            throw 'DB error' if err

            unless post
                res.send {}
                client.end()
                return

            post = parser.decode post
            post.abstract = jade.render post.abstract
            post.post = jade.render post.post
            res.send post
            client.hincrby [key, 'hits', 1], (err, response) ->
                throw 'DB error' if err
                client.end()