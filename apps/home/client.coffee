Util = require '../../components/Util/index.coffee'

class HomeView extends Backbone.View

    className: 'app-home'

    events:
        'click [data-behavior~=read-more]': 'handleReadMore'
        'swipeleft': 'handleReadMore'
        'keyup': 'handleKeyPress'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require './templates/index.jade'

    render: ->
        @$el.html @constructor.template()
        @$el.focus()

    ###
    # Handlers
    ###

    handleReadMore: ->
        @router.navigate 'portfolio',
            trigger: true
        false

    handleKeyPress: (e) ->
        if e.which is Util.keys.arrowRight
            @handleReadMore()

module.exports = HomeView
