define 'ApplicationModel',
['HomeModel', 'PortfolioCollection'],
(HomeModel, PortfolioCollection) ->

    components = {}

    class ApplicationModel extends Backbone.Model

        initialize: ->
            router = @get 'router'
            @listenTo router, 'navigate:home', @renderHome
            @listenTo router, 'navigate:portfolio', @renderPortfolio

            @registerComponent 'home',
                modelKlass: HomeModel

            @registerComponent 'portfolio',
                collectionKlass: PortfolioCollection
                options:
                    templates: null

        start: ->
            Backbone.history.start pushState: true

        registerComponent: (id, component) ->
            components[id] = component

        getComponent: (id) ->
            return unless id of components

            component = _.defaults components[id],
                models: null
                attributes: {}
                options: {}

            unless component.instance
                if component.collectionKlass
                    klass = component.collectionKlass
                    arg1 = component.models
                else
                    klass = component.modelKlass
                    arg1 = component.attributes

                if 'templates' of component.options
                    component.options.templates = @get 'templates'

                component.instance = new klass arg1, component.options

            instance: component.instance
            type: if component.collectionKlass then 'collection' else 'model'

        renderHome: ->
            {instance} = @getComponent 'home'
            @set activeComponent: 'home'

        renderPortfolio: ->
            {instance} = @getComponent 'portfolio'
            @set activeComponent: 'portfolio'

    ApplicationModel
