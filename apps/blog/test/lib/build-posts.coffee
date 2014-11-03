builder = require '../../lib/build-posts'
fs = require 'fs'
redis = require 'redis'
path = require 'path'
parser = require '../../lib/post-parser'
Util = require '../../../../components/Util'

client = redis.createClient()

client.on 'connect', ->

    describe 'build-posts', ->

        before ->
            @templatesPath =  path.join __dirname, '../templates'
            @postsPath = path.join @templatesPath, 'posts'

        describe '#getPosts', ->

            before ->
                @postFiles = fs.readdirSync @postsPath
                @builderPosts = builder.getPosts @postsPath

            it 'throws error with improperly named post files', ->
                do( ->
                    path = path.join @templatesPath, 'posts-invalid-name'
                    builder.getPosts path
                ).should.throwError

            it 'throws error when two posts have the same slug', ->
                do( ->
                    builder.getPosts path.join @templatesPath, 'posts-same-slug'
                ).should.throwError

            it 'gets posts', ->
                @builderPosts.length.should.be.exactly @postFiles.length

            it 'getPosts should return an array', ->
                @builderPosts.should.be.an.Array

            it 'getPosts array should contain objects', ->
                for post in @builderPosts
                    post.should.be.an.Object

        describe '#getTags', ->

            before ->
                @posts = [
                    tags: ['a', 'b']
                    slug: 'first-post'
                ,
                    tags: ['a']
                    slug: 'second-post'
                ,
                    tags: ['b', 'c']
                    slug: 'third-post'
                ]

            it 'returns an object when an empty object is passed', ->
                builder.getTags(@posts).should.be.an.Object

            it 'returns an object when posts are passed', ->
                builder.getTags(@posts).should.be.an.Object

            it 'returns tags', ->
                builder.getTags(@posts).should.eql
                    a: ['first-post', 'second-post']
                    b: ['first-post', 'third-post']
                    c: ['third-post']

        describe '#build', ->

            before (done) ->
                @builderPosts = builder.getPosts @postsPath
                @builderTags = builder.getTags @builderPosts
                builder.getPosts = => @builderPosts

                # Custom namespace
                @config = require '../config/redis.json'
                builder.build @config, done

                @keysToDelete = [@config.postorderKey, @config.tagsKey]

            # Comment out if debugging
            after (done) ->
                client.del @keysToDelete, (err, response) ->
                    throw 'Request error' if err
                    done()

            it 'populates postorder key', (done) ->
                client.zcard @config.postorderKey, (err, count) =>
                    throw 'Request error' if err
                    count.should.be.exactly @builderPosts.length
                    done()

            it 'sets score to unix timestamp', (done) ->
                slug = @builderPosts[0].slug
                timestamp = @builderPosts[0].date.getTime() / 1000

                client.zscore [@config.postorderKey, slug], (err, response) ->
                    throw 'Request error' if err
                    response = parseInt response, 10
                    response.should.be.exactly timestamp
                    done()

            it 'populates each post', (done) ->
                check = (post, next) =>
                    key = "#{@config.postKey}:#{post.slug}"
                    @keysToDelete.push key

                    client.hgetall key,(err, hash) ->
                        throw 'Request error' if err

                        parser.decode hash
                        hash.should.containDeep post
                        next()

                Util.syncLoop @builderPosts, check, done

            it 'populates tags key', (done) ->
                client.get @config.tagsKey, (err, response) =>
                    throw 'Request error' if err
                    JSON.parse(response).should.eql Object.keys @builderTags
                    done()

            it 'populates each tag key', (done) ->
                tagNames = Object.keys @builderTags

                check = (tag, next) =>
                    key = "#{@config.tagKey}:#{tag}"
                    @keysToDelete.push key

                    client.smembers key,(err, posts) =>
                        throw 'Request error' if err

                        posts.should.containDeep @builderTags[tag]
                        next()

                Util.syncLoop tagNames, check, done
