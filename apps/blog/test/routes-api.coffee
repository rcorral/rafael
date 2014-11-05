builder = require '../lib/build-posts'
path = require 'path'
Posts = require '../../../collections/posts'
routesAPI = require '../routes-api'

describe 'routes-api', ->

    describe '#posts', ->

        before (done) ->
            postsPath = path.join __dirname, 'templates/posts'

            routesAPI.config = require './config/redis.json'
            builderPosts = builder.getPosts postsPath
            builder.getPosts = -> builderPosts
            builder.build routesAPI.config, done

        it 'returns the total number of posts', (done) ->
            req = params: page: 0
            res = send: (response) ->
                response.total.should.be.a.Number
                response.total.should.greaterThan 0
                done()

            routesAPI.posts req, res

        it "only doesn't return more than #{Posts::POSTS_PER_PAGE} posts at a time", (done) ->
            req = params: page: 0
            res = send: (response) ->
                response.posts.length.should.be.exactly Posts::POSTS_PER_PAGE
                done()

            routesAPI.posts req, res

        it 'paginates', (done) ->
            req = params: page: 0
            res = send: (firstSet) ->
                req = params: page: 1
                res = send: (secondSet) ->
                    secondSet.posts.should.not.containDeep firstSet.posts
                    done()
                routesAPI.posts req, res

            routesAPI.posts req, res

        it 'only returns results with necessary data', (done) ->
            req = params: page: 0
            res = send: (response) ->
                response.posts[0].should.not.have.property 'post'
                done()

            routesAPI.posts req, res

        it 'returns parsed posts', (done) ->
            req = params: page: 0
            res = send: (response) ->
                response.posts[0].date.should.be.an.instanceOf Date
                response.posts[0].tags.should.be.an.instanceOf Array
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

        it 'returns the requested post', (done) ->
            req = params: post: 'first-post'
            res = send: (post) ->
                post.should.be.an.Object
                post.post.should.be.ok
                post.title.should.be.ok
                post.tags.should.an.Array
                post.slug.should.be.exactly 'first-post'
                done()
            routesAPI.post req, res

        it 'increments hits', (done) ->
            req = params: post: 'first-post'
            res = send: (post) ->
                currentHits = post.hits
                req = params: post: 'first-post'
                res = send: (post) ->
                    post.hits.should.be.exactly currentHits + 1
                    done()
                routesAPI.post req, res
            routesAPI.post req, res
