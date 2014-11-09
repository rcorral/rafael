Post = require '../../models/post'
sinon = require 'sinon'
sd = require('sharify').data

describe 'Post', ->

    sd.API_URL = 'http://example.com'

    it 'uses API_URL as url', ->
        post = new Post
        post.urlRoot().should.equal "#{sd.API_URL}/api/posts"

    it 'builds #frontEndUrl from ID', ->
        post = new Post id: 'hello-world'
        post.frontEndUrl().should.equal "/blog/#{post.id}"

    it 'parses date', ->
        dbDate = '2014-08-26T10:12:00.000Z'
        post = new Post date: dbDate,
            parse: true
        date = post.get 'date'
        date.should.be.an.instanceOf Date
        date.getTime().should.equal new Date(dbDate).getTime()

    it '#parse sets id to post.slug', ->
        post = new Post slug: 'hello-world',
            parse: true
        post.id.should.equal post.get 'slug'

    it '#parse doesn\'t override id if set', ->
        post = new Post {id: 'cruel-world', slug: 'hello-world'},
            parse: true
        post.id.should.equal 'cruel-world'

    describe '#toJSON', ->

        before ->
            @attributes =
                slug: 'hello-world'
                date: '2014-08-26T10:12:00.000Z'
            post = new Post @attributes, parse: true
            @json = post.toJSON()

        it 'is an object', ->
            @json.should.be.an.instanceOf Object

        it 'contains frontEndUrl', ->
            @json.postUrl.should.be.equal "/blog/#{@attributes.slug}"

        it 'creates uiDate', ->
            @json.uiDate.should.be.an.instanceOf Object

        it 'contains ui formatted dates', ->
            /[0-9]{4}-[0-9]{2}-[0-9]{2}/.test(@json.uiDate.yyyymmdd).should.be.ok
            @json.uiDate.friendly.should.be.an.instanceOf String

    describe '#loadPost', ->

        beforeEach ->
            @post = new Post slug: 'hello-world', title: 'something else'
            @post.fetch = ->

        it 'clears all attributes', ->
            @post.loadPost null
            @post.has('slug').should.not.be.ok
            @post.has('title').should.not.be.ok

        it 'sets id as new id', ->
            @post.loadPost 'my-new-id'
            @post.get('id').should.equal 'my-new-id'
            @post.id.should.equal 'my-new-id'

        it 'fetches post from server', ->
            @post.fetch = sinon.spy()
            @post.loadPost null
            @post.fetch.calledOnce.should.be.ok
