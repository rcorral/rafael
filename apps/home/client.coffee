Util = require '../../components/Util/index.coffee'

class HomeView extends Backbone.View

    className: 'app-home'

    events:
        'click [data-behavior~=read-more]': 'handleReadMore'
        'swipeleft': 'handleReadMore'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require './templates/index.jade'

    render: ->
        @$el.html @constructor.template()
        @$el.focus()

    delegateEvents: ->
        super
        $('body').on 'keyup.homeDelegateEvents', @handleKeyPress.bind @

    undelegateEvents: ->
        super
        $('body').off '.homeDelegateEvents'

    ###
    # Handlers
    ###

    handleReadMore: ->
        @router.navigate 'portfolio',
            trigger: true
        false

    handleKeyPress: (e) ->
        return unless @model.get 'isActive'
        if e.which is Util.keys.arrowRight
            @handleReadMore()

module.exports = HomeView
