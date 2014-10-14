express = require 'express'

app = module.exports = express()
app.use require('./routes')(app)
