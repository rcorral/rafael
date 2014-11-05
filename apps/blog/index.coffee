express = require 'express'
app = module.exports = express()

redis = require 'redis'
client = redis.createClient()
client.on 'connect', -> client.end()
client.on 'error', -> throw 'DB connection error.'

# Routes
routes = require './routes'
routes.init app
app.get '/blog/:post', routes.post # must be first b/c of regex
app.get /^\/blog\/?(?:page)?(?:\/([^\/]+?))?\/?$/, routes.posts

# API Routes
routesAPI = require './routes-api'
app.get '/api/posts/page/:page/', routesAPI.posts
app.get '/api/posts/:post/', routesAPI.post
