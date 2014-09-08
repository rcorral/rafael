define 'ApplicationView',
['NavbarView', 'HomeView', 'PortfolioView'],
(NavbarView, HomeView, PortfolioView) ->

    componentViews = {}

    class ApplicationView extends Backbone.View

        initialize: ->
            router = @model.get 'router'
            @$componentsContainer = $ '.components-container'

            @registerComponent 'home',
                klass: HomeView
                options: {router}

            @registerComponent 'portfolio',
                klass: PortfolioView

            @registerPartials()
            @registerTemplates()

            @navbarView = new NavbarView
                el: $ 'header'
                templates: @model.get('templates')
                router: router
                model: @model

            # Listeners
            @listenTo @model, 'change:activeComponent', @renderActiveComponent
            @listenToOnce router, 'route', (destination) ->
                $('.site-intro').hide() if destination isnt 'home'

        render: ->
            @navbarView.render()

        registerComponent: (id, component) ->
            componentViews[id] = component

        getComponentView: (id) ->
            return unless id of componentViews

            component = componentViews[id]

            unless component.instance
                _.defaults component,
                    options: {}
                {instance, type} = @model.getComponent id
                component.options[type] = instance
                view = new component.klass component.options
                @$el.append view.el unless id is 'home'
                component.instance = view

            component.instance

        renderActiveComponent: (model, component) ->
            view = @getComponentView component
            previousComponent = @model.previous 'activeComponent'
            if previousComponent?
                previousView = @getComponentView previousComponent
                previousView.$el.hide()
            if component is 'home'
                @$componentsContainer.hide()
            else
                @$componentsContainer.show()

            view.$el.show()
            view.render()
            @scrollToTop()

        registerPartials: ->
            $('script[type="text/x-handlebars-template"][data-type=partial]').each (i, template)->
                Handlebars.registerPartial template.id, template.innerHTML

        registerTemplates: ->
            templates = {}
            $('script[type="text/x-handlebars-template"]').each (i, template) ->
                templates[template.id] =
                    rawTemplate: template.innerHTML
                    template: Handlebars.compile template.innerHTML
                    sort: jQuery("##{template.id}").data('sort') or 0
            @model.set templates: templates

        scrollToTop: ->
            $('html, body').animate
                'scrollTop': 0
            , 'fast', 'swing'

    ApplicationView
