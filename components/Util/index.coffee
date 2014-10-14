Util = {}

Util.keys = require './keys.coffee'

Util.capitalize = (str) ->
    str.replace /(^\s*)(\S)(.*)$/g, (match, whitespace, firstLetter, rest) ->
         whitespace + firstLetter.toUpperCase() + rest

module.exports = Util
