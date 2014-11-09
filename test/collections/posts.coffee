Post = require '../../models/post'
Posts = require '../../collections/posts'
sinon = require 'sinon'
sd = require('sharify').data

describe 'Posts', ->

    sd.API_URL = 'http://example.com'

    it 'declares the amount of posts to show per page', ->
        Posts::POSTS_PER_PAGE.should.be.an.instanceOf Number

    it 'uses Post as the model', ->
        new Posts::model().should.be.an.instanceOf Post

    it 'uses API_URL when building API url', ->
        posts = new Posts
        posts.url().should.be.equal "#{sd.API_URL}/api/posts/page/#{posts.page}"

    it 'uses page when building API url', ->
        posts = new Posts
        posts.page = 3
        posts.url().should.be.equal "#{sd.API_URL}/api/posts/page/3"

    describe '#frontEndUrl', ->

        it 'builds url for first page', ->
            Posts::frontEndUrl(0).should.equal '/blog'

        it 'builds url for page id', ->
            Posts::frontEndUrl(3).should.equal '/blog/page/3'

    describe '#initialize', ->

        it 'sets page from options', ->
            posts = new Posts [], page: 3
            posts.page.should.be.exactly 3

        it 'sets total from options', ->
            posts = new Posts [], total: 10
            posts.total.should.be.exactly 10

    describe '#parse', ->
        it 'sets total', ->
            posts = new Posts
            posts.parse total: 2
            posts.total.should.be.exactly 2

        it 'returns posts', ->
            models = [
                    a: 'a'
                ,
                    b: 'b'
                ]
            posts = new Posts
            posts.parse(total: 2, posts: models).should.containDeep models

    describe '#loadPage', ->

        beforeEach ->
            @posts = new Posts
            @posts.fetch = sinon.spy()

        it 'sets current page', ->
            @posts.loadPage 3
            @posts.page.should.be.exactly 3

        it 'fetches requested page', ->
            @posts.loadPage 3
            @posts.fetch.calledOnce.should.be.ok

    describe '#forTemplate', ->

        before ->
            @models = [
                    a: 'a'
                ,
                    b: 'b'
                ]
            @posts = new Posts @models,
                page: 0
                total: 11
            @context = @posts.forTemplate()

        it 'contains posts', ->
            @context.posts.should.be.an.instanceOf Array
            @context.posts.should.containDeep @models

        it 'contains page', ->
            @context.page.should.be.exactly 0

        it 'calculates if it\'s the first blog posts page', ->
            @context.isFirstPage.should.be.ok

        it 'calculates if it\'s the first blog posts page', ->
            @posts.page = 1
            @posts.forTemplate().isFirstPage.should.not.be.ok

        it 'calculates if it\'s the last page', ->
            @context.isLastPage.should.not.be.ok

        it 'calculates if it\'s the last page', ->
            @posts.page = 1
            @posts.forTemplate().isLastPage.should.be.ok

        it 'calculates previous page url', ->
            @context.prevPageUrl.should.equal Posts::frontEndUrl(0)

        it 'calculates previous page url', ->
            @posts.page = 1
            @posts.forTemplate().prevPageUrl.should.equal Posts::frontEndUrl(0)

        it 'calculates next page url', ->
            @context.nextPageUrl.should.equal Posts::frontEndUrl(1)

        it 'calculates next page url', ->
            @posts.page = 1
            @posts.forTemplate().nextPageUrl.should.equal Posts::frontEndUrl(2)
