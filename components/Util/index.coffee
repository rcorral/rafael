Util = {}

Util.keys = require './keys.coffee'

Util.capitalize = (str) ->
    str.replace /(^\s*)(\S)(.*)$/g, (match, whitespace, firstLetter, rest) ->
         whitespace + firstLetter.toUpperCase() + rest

Util.syncLoop = (array, iteratee, end) ->
    cursor = -1
    next = ->
        cursor++

        if array[cursor]
            iteratee array[cursor], next
        else
            end()

    next()

module.exports = Util
