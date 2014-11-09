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
            builder.build routesAPI.config, =>
                req = params: page: 0
                res = send: (response) =>
                    @firstPage = response
                    req = params: page: 1
                    res = send: (response) =>
                        @secondPage = response
                        done()

                    routesAPI.posts req, res

                routesAPI.posts req, res

        it 'returns the total number of posts', ->
            @firstPage.total.should.be.a.Number
            @firstPage.total.should.greaterThan 0

        it "doesn't return more than #{Posts::POSTS_PER_PAGE}", ->
            @firstPage.posts.length.should.be.exactly Posts::POSTS_PER_PAGE

        it 'paginates', ->
            @secondPage.posts.should.not.containDeep @firstPage.posts

        it 'only returns results with necessary data', ->
            @firstPage.posts[0].should.not.have.property 'post'

        it 'returns parsed posts', ->
            @firstPage.posts[0].date.should.be.an.instanceOf Date
            @firstPage.posts[0].tags.should.be.an.instanceOf Array
            @firstPage.posts[0].hits.should.be.an.instanceOf Number if @firstPage.posts[0].hits

        it 'returns posts in decending chronological order', ->
            for results in [@firstPage, @secondPage]
                for post in results.posts
                    if prevPost
                        prevPost.date.getTime().should.be.greaterThan post.date.getTime()
                    prevPost = post

        it 'returns 400 with an invalid page number', (done) ->
            req = params: page: -1
            res =
                end: done
                status: (code) ->
                    code.should.be.exactly 400
                    @

            routesAPI.posts req, res

        it 'returns 404 when a non-existent page is request', (done) ->
            req = params: page: 999999
            res =
                end: done
                status: (code) ->
                    code.should.be.exactly 404
                    @

            routesAPI.posts req, res

    describe '#post', ->

        before (done) ->
            routesAPI.config = require './config/redis.json'
            req = params: post: 'first-post'
            res = send: (post) =>
                @post = post
                done()
            routesAPI.post req, res

        it 'returns 404 when requesting a non-existent post', (done) ->
            req = params: post: 'non-existent'
            res =
                end: done
                status: (code) ->
                    code.should.be.exactly 404
                    @
            routesAPI.post req, res

        it 'returns 400 with an invalid request', (done) ->
            req = params: post: 'something!@#-inva($@'
            res =
                end: done
                status: (code) ->
                    code.should.be.exactly 400
                    @
            routesAPI.post req, res

        it 'returns the requested post', ->
            @post.should.be.an.Object
            @post.post.should.be.ok
            @post.title.should.be.ok
            @post.tags.should.an.Array
            @post.slug.should.be.exactly 'first-post'

        it 'increments hits', (done) ->
            @post.hits ?= 0
            req = params: post: 'first-post'
            res = send: (post) =>
                post.hits.should.be.exactly @post.hits + 1
                done()
            routesAPI.post req, res
