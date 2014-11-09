appLocals = require '../../lib/app-locals'
sd = require('sharify').data

describe 'app-locals', ->

    it 'exports getHost property', ->
        appLocals.getHost.should.be.an.instanceOf Function

    describe '#getHostFn', ->

        it 'returns a function', ->
            sd.ENV = 'development'
            sd.HOST = 'example.com'
            sd.port = 5000
            appLocals.getHostFn().should.be.an.instanceOf Function

        describe 'in development', ->

            before ->
                sd.ENV = 'development'
                sd.HOST = 'example.com'
                sd.port = 5000
                delete sd.CDN_HOSTS if sd.CDN_HOSTS
                @getHosts = appLocals.getHostFn()

            it 'returns url with protocol', ->
                @getHosts().should.be.exactly "http://#{sd.HOST}:#{sd.PORT}"

            it 'always returns the same host', ->
                @getHosts().should.be.exactly @getHosts()

        describe 'in production', ->

            before ->
                sd.ENV = 'production'
                sd.CDN_HOSTS = 'cdn1.example.com,cdn2.example.com'
                @getHosts = appLocals.getHostFn()

            it 'returns url without protocol', ->
                @getHosts().should.not.containEql 'http://'

            it 'urls begin with //', ->
                /^\/\//.test @getHosts()

            it 'iterates throw cdn hosts', ->
                @getHosts().should.not.be.exactly @getHosts()
