Util = {}

Util.keys = require './keys.coffee'

Util.capitalize = (str) ->
    str.replace /(^\s*)(\S)(.*)$/g, (match, whitespace, firstLetter, rest) ->
         whitespace + firstLetter.toUpperCase() + rest

Util.pluralize = (string, arity) ->
    arity ?= 2

    return "" if string.length is 0

    arity = parseInt arity, 10

    if arity isnt 1
      string = string.replace(/y$/, "ie") + "s";

    string

Util.syncLoop = (array, iteratee, end) ->
    cursor = -1
    next = ->
        cursor++

        if array[cursor]
            iteratee array[cursor], next
        else
            end()

    next()

Util.scrollToTop = (position=0) ->
    $('html, body').animate
        'scrollTop': position
    , 'fast', 'swing'

# @param  {String} category   Typically the object that was interacted with (e.g. button)
# @param  {String} action     The type of interaction (e.g. click)
# @param  {String} [label]    Useful for categorizing events (e.g. nav buttons)
# @param  {Number} [value]    Values must be non-negative. Useful to pass counts (e.g. 4 times)
# @param  {Object} [options]  Options
Util.trackEvent = (category, action, label, value, options) ->
    ga = window[window.GoogleAnalyticsObject]
    return unless ga
    args = new Array arguments.length
    `for (i = 0; i < args.length; ++i) {args[i] = arguments[i];}`
    args.unshift 'event'
    args.unshift 'send'
    ga.apply null, args

module.exports = Util
