builder = require '../lib/build-posts'
path = require 'path'
routesAPI = require '../routes-api'

describe 'routes-api', ->

    describe '#posts', ->

        before (done) ->
            postsPath = path.join __dirname, 'templates/posts'

            routesAPI.config = require './config/redis.json'
            builderPosts = builder.getPosts postsPath
            builder.getPosts = -> builderPosts
            builder.build routesAPI.config, done

        it 'only doesn\'t return more than 10 posts at a time', (done) ->
            req = params: page: 0
            res = send: (posts) ->
                posts.length.should.be.exactly 10
                done()

            routesAPI.posts req, res

        it 'paginates', (done) ->
            req = params: page: 0
            res = send: (firstSet) ->
                req = params: page: 1
                res = send: (secondSet) ->
                    secondSet.should.not.containDeep firstSet
                    done()
                routesAPI.posts req, res

            routesAPI.posts req, res

        it 'only returns results with necessary data', (done) ->
            req = params: page: 0
            res = send: (posts) ->
                posts[0].should.not.have.property 'post'
                done()

            routesAPI.posts req, res

        it 'returns parsed posts', (done) ->
            req = params: page: 0
            res = send: (posts) ->
                posts[0].date.should.be.an.instanceOf Date
                posts[0].tags.should.be.an.instanceOf Array
                done()

            routesAPI.posts req, res

    describe '#post', ->

        before ->
            routesAPI.config = require './config/redis.json'

        it 'returns an empty object with a non-existent post slug', (done) ->
            req = params: post: 'non-existent'
            res = send: (post) ->
                post.should.be.an.Object
                post.should.be.empty
                done()
            routesAPI.post req, res

        it 'returns an empty object with a invalid post slug', (done) ->
            req = params: post: 'something!@#-inva($@'
            res = send: (post) ->
                post.should.be.an.Object
                post.should.be.empty
                done()
            routesAPI.post req, res
