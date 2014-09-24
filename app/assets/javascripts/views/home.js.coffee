define 'HomeView',
['Util'],
(Util) ->

    class HomeView extends Backbone.View

        className: 'site-intro'

        events:
            'click [data-behavior~=read-more]': 'handleReadMore'
            'swipeleft': 'handleReadMore'
            'keyup': 'handleKeyPress'

        initialize: (options) ->
            @router = options.router
            $el = $ ".#{@className}"
            @setElement $el
            $el.focus()

        ###
        # Handlers
        ###

        handleReadMore: ->
            @router.navigate 'portfolio',
                trigger: true

        handleKeyPress: (e) ->
            if e.which is Util.keys.arrowRight
                @handleReadMore()

    HomeView
