_ = require 'underscore'
jade = require 'jade'
parser = require './lib/post-parser'
Posts = require '../../collections/posts'
redis = require 'redis'
Util = require '../../components/Util'

module.exports.posts = (req, res) ->
    @config ?= require './config/redis.json'
    client = redis.createClient()
    fields = ['title', 'slug', 'date', 'tags', 'abstract']

    return res.status(400).end() if req.params.page < 0

    client.on 'connect', =>
        start = req.params.page * Posts::POSTS_PER_PAGE
        stop = start + Posts::POSTS_PER_PAGE - 1
        client.zcard @config.postorderKey, (err, total) =>
            throw 'DB error' if err

            # Return early
            return res.status(404).end() if start > total

            client.zrevrange [@config.postorderKey, start, stop], (err, postKeys) =>
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

                Util.syncLoop postKeys, getPost, =>
                        client.end()
                        res.send {total, posts}

module.exports.post = (req, res) ->
    @config ?= require './config/redis.json'
    client = redis.createClient()

    return res.status(400).end() if req.params.post isnt req.params.post.replace /[^a-z0-9\-]/, ''

    client.on 'connect', =>
        key = "#{@config.postKey}:#{req.params.post}"
        client.hgetall key, (err, post) ->
            throw 'DB error' if err

            return res.status(404).end() unless post

            post = parser.decode post
            post.abstract = jade.render post.abstract
            post.post = jade.render post.post
            res.send post
            client.hincrby [key, 'hits', 1], (err, response) ->
                throw 'DB error' if err
                client.end()
