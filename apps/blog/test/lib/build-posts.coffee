builder = require '../../lib/build-posts'
fs = require 'fs'
redis = require 'redis'
path = require 'path'
parser = require '../../lib/post-parser'

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

        describe '#build', ->

            before (done) ->
                @builderPosts = builder.getPosts @postsPath
                builder.getPosts = => @builderPosts

                # Custom namespace
                @config =
                    postorderKey: 'test-postorder'
                    postKey: 'test-post'
                builder.build @config, done

                @keysToDelete = [@config.postorderKey]

            # Comment out if debugging
            after (done) ->
                client.del @keysToDelete, (err, response) ->
                    throw 'Request error' if err
                    done()

            it 'postorder key should be populated', (done) ->
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

            it 'posts should be populated', (done) ->
                cursor = 0

                check = (post, next) =>
                    key = "#{@config.postKey}:#{post.slug}"
                    @keysToDelete.push key

                    client.hgetall key,(err, hash) ->
                        throw 'Request error' if err

                        parser.decode hash
                        hash.should.eql post
                        next()

                next = =>
                    cursor++

                    if @builderPosts[cursor]
                        check @builderPosts[cursor], next
                    else
                        done()

                check @builderPosts[cursor], next
