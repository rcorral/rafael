define 'ApplicationModel',
['TemplatesModel', 'PortfolioCollection'],
(TemplatesModel, PortfolioCollection) ->

    components = {}

    class ApplicationModel extends Backbone.Model

        initialize: ->
            router = @get('router')
            @listenTo router, 'navigate:portfolio', @renderPortfolio

            @set
                templates: new TemplatesModel

            @registerComponent 'portfolio',
                collectionKlass: PortfolioCollection
                options:
                    templates: @get 'templates'

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

                component.instance = new klass arg1, component.options

            instance: component.instance
            type: if component.collectionKlass then 'collection' else 'model'

        renderPortfolio: ->
            {instance} = @getComponent 'portfolio'
            @set activeComponent: 'portfolio'

    ApplicationModel
