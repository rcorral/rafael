define 'ApplicationModel',
['DummyModel', 'PortfolioCollection', 'Util'],
(DummyModel, PortfolioCollection, Util) ->

    components = {}

    class ApplicationModel extends Backbone.Model

        initialize: ->
            router = @get 'router'
            @listenTo router, 'navigate:home', @renderComponent
            @listenTo router, 'navigate:portfolio', @renderComponent
            @listenTo router, 'navigate:about', @renderComponent

            @registerComponent 'home',
                modelKlass: DummyModel

            @registerComponent 'portfolio',
                collectionKlass: PortfolioCollection

            @registerComponent 'about',
                modelKlass: DummyModel

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
                    component.options.templates = @get 'templates'
                else
                    klass = component.modelKlass
                    arg1 = component.attributes
                    component.attributes.templates = @get 'templates'

                component.instance = new klass arg1, component.options

            instance: component.instance
            type: if component.collectionKlass then 'collection' else 'model'

        # Renders a component that doesn't need any special treatment
        renderComponent: (component) ->
            {instance} = @getComponent component
            @set
                activeComponent: component
                title: Util.capitalize component

    ApplicationModel
