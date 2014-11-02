_ = require 'underscore'
debug = require('debug')('debug')
fs = require 'fs'
path = require 'path'
parser = require './post-parser'
redis = require 'redis'
Util = require '../../../components/Util'

module.exports.getPosts = (postsPath) ->
    postsPath ?= path.join __dirname, '..', 'templates', 'posts'
    postFiles = fs.readdirSync postsPath
    slugs = []

    throw 'No posts found' unless postFiles.length

    for fileName in postFiles
        matches = fileName.match /([\d]{4}-[\d]{2}-[\d]{2})-(.*)\.jade/
        if not matches or not matches[1] or not matches[2]
            throw 'Invalid post filename.'

        if matches[2] in slugs
            throw 'Can\'t have two posts with the same slug.'
        slugs.push matches[2]

        filePath = path.join postsPath, fileName
        fileContents = fs.readFileSync filePath, encoding: 'utf8'

        declaration = _.extend parser.parse(fileContents),
            slug: matches[2]

        declaration

# Gets tags from posts
module.exports.getTags = (posts) ->
    tags = {}
    return tags unless posts.length

    for post in posts
        for tag in post.tags
            tags[tag] ?= []
            tags[tag].push post.slug
    tags

module.exports.build = (config, callback) ->
    config ?= require '../config/redis.json'
    client = redis.createClient()

    writePost = (_post, next) ->
        post = _.clone _post
        timestamp = post.date.getTime() / 1000
        args = [config.postorderKey, timestamp, post.slug]

        # Write post to sorted set
        # allows us to have ordering of posts/pagination
        client.zadd args, (err, response) ->
            throw err if err

            # Write individual post with all it's properties
            parser.encode post
            client.hmset "#{config.postKey}:#{post.slug}", post, (err, response) ->
                throw err if err
                next()

    writeTags = (tags, callback) ->
        tagNames = Object.keys tags
        return callback() unless tagNames.length

        # Writes tag with all posts that have the tag
        writeTag = (tag, next) ->
            args = _.clone tags[tag]
            args.unshift "#{config.tagKey}:#{tag}"

            client.sadd args, (err, response) ->
                throw err if err
                next()

        # These could be stored as a sorted set
        # if we wanted to quickly get counts
        client.set [config.tagsKey, JSON.stringify(tagNames)], (err, response) ->
            throw err if err
            Util.syncLoop tagNames, writeTag, callback

    client.on 'connect', =>
        posts = @getPosts()
        tags = @getTags posts

        Util.syncLoop posts, writePost, ->
            writeTags tags, ->
                debug "Added #{posts.length} posts."
                callback?()
                client.end()
