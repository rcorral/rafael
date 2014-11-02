express = require 'express'
app = module.exports = express()

routes = require './routes'
routes.init app
routesAPI = require './routes-api'

app.use '/blog', routes.index
app.use '/api/posts/page/:page/', routesAPI.posts
