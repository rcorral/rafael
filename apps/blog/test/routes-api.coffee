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
