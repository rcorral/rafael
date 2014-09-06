define 'HomeView', ->

    class HomeView extends Backbone.View

        className: 'site-intro'

        events:
            'click [data-behavior~=read-more]': 'handleReadMore'

        initialize: (options) ->
            @router = options.router
            @setElement $ ".#{@className}"

        render: ->

        ###
        # Handlers
        ###

        handleReadMore: (e) ->
            @router.navigate 'portfolio',
                trigger: true

    HomeView
