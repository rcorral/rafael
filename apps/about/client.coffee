appLocals = require '../../lib/app-locals.coffee'

class AboutView extends Backbone.View

    className: 'app-about'

    events:
        'click [data-behavior~=email-prompt]': 'handleEmailPrompt'

    initialize: ->
        @constructor.template = require './templates/index.jade'

    render: ->
        @$el.html @constructor.template appLocals

    handleEmailPrompt: ->
        prefix = '&#109;a' + 'i&#108;' + '&#116;o'
        addy24102 = 'm&#101;' + '&#64;'
        addy24102 = addy24102 + 'r&#97;f&#97;&#101;lc&#111;rr&#97;l' + '&#46;' + 'c&#111;m'
        link = $('<a/>').html("#{prefix}:#{addy22002}").text()
        window.location.href = link

module.exports = AboutView
