_ = require 'underscore'
buildPosts = require '../../lib/build-posts'
parser = require '../../lib/post-parser'

describe 'post-parser', ->

    before ->
        posts = buildPosts.getPosts()
        @post = posts[0]

    describe '#parse', ->

        it 'should be a function', ->
            parser.parse.should.be.a.Function

    describe '#encode', ->

        it 'encodes post', ->
            post = _.clone @post
            parser.encode(post).should.not.eql @post

    describe '#decode', ->

        it 'decodes post', ->
            post = _.clone @post
            encoded = parser.encode post
            parser.decode(_.clone(encoded)).should.not.eql encoded

    describe '#encode#decode', ->

        it 'encoding post and decoding equals original post', ->
            post = _.clone @post
            parser.decode(parser.encode(post)).should.eql @post
