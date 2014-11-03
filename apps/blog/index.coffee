express = require 'express'
app = module.exports = express()

redis = require 'redis'
client = redis.createClient()
client.on 'connect', -> client.end()
client.on 'error', -> throw 'DB connection error.'

routes = require './routes'
routes.init app
routesAPI = require './routes-api'

app.get '/blog', routes.index
app.get '/api/posts/page/:page/', routesAPI.posts
app.get '/api/posts/:post/', routesAPI.post
