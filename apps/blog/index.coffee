express = require 'express'
app = module.exports = express()

routes = require './routes'
routes.init app
routesAPI = require './routes-api'

app.get '/blog', routes.index
app.get '/api/posts/page/:page/', routesAPI.posts
