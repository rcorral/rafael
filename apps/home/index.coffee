express = require 'express'
app = module.exports = express()

routes = require './routes'
routes.init app

app.get '/', routes.index
