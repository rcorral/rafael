_ = require 'underscore'
fs = require 'fs'
path = require 'path'
parser = require('./lib/post-language.js').parser
redis = require 'redis'

module.exports.getPosts = ->
    postFiles = fs.readdirSync path.join __dirname, 'templates/posts'

    throw 'No posts found' unless postFiles.length

    for fileName in postFiles
        matches = fileName.match /([\d]{4}-[\d]{2}-[\d]{2})-(.*)\.jade/
        if not matches or not matches[1] or not matches[2]
            throw 'Invalid post filename.'

        filePath = path.join __dirname, 'templates/posts', fileName
        fileContents = fs.readFileSync filePath, encoding: 'utf8'

        declaration = _.extend parser.parse(fileContents),
            slug: matches[2]

        declaration

module.exports.build = (config) ->
    config ?= require './config/redis.json'
    client = redis.createClient()

    write = (post, next) ->
        timestamp = post.date.getTime() / 1000
        args = [config.postorderKey, timestamp, post.slug]

        client.zadd args, (err, response) ->
            throw err if err
            client.hmset "#{config.postKey}:#{post.slug}", post, (err, response) ->
                throw err if err
                next()

    posts = @getPosts()

    client.on 'connect', ->
        cursor = 0

        next = ->
            cursor++

            if posts[cursor]
                write posts[cursor], next
            else
                client.end()

        write posts[cursor], next
