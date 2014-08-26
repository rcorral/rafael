define 'ApplicationModel',
['PortfolioModel'],
(PortfolioModel) ->

    components = {}

    class ApplicationModel extends Backbone.Model

        initialize: ->
            router = @get('router')
            @listenTo router, 'navigate:portfolio', @renderPortfolio

            @registerComponent 'portfolio',
                klass: PortfolioModel

        start: ->
            Backbone.history.start pushState: true

        registerComponent: (id, component) ->
            components[id] = component

        getComponent: (id) ->
            return unless id in components
            component = components[id]
            unless component.instance
                component.instance = new component.klass
            component.instance

        renderPortfolio: ->
            component = @getComponent 'portfolio'
            @set activeComponent: 'portfolio'

    ApplicationModel
