define 'NavbarView', ->

    class NavbarView extends Backbone.View

        events:
            'click [data-behavior~=route]': 'handleRouteClick'

        initialize: (options) ->
            @model = options.model
            @constructor.template = options.templates['navbar-template'].template
            @listenTo @model, 'change:activeComponent', @render
            @renderCount = 0

        render: ->
            activeComponent = @model.get 'activeComponent'
            return if @renderCount is 0 and activeComponent is 'home'

            @renderCount++
            context = {}
            context["#{activeComponent}Active"] = true
            $('header').html @constructor.template context

        handleRouteClick: (e) ->
            $el = $ e.currentTarget
            @model.get('router').navigate $el.attr('href'),
                trigger: true
            false

    NavbarView
