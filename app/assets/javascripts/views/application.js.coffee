define 'ApplicationView',
['PortfolioView'],
(PortfolioView) ->

    componentViews = {}

    class ApplicationView extends Backbone.View

        initialize: ->
            @listenTo @model, 'change:activeComponent', @renderActiveComponent

            @registerComponent 'portfolio',
                klass: PortfolioView

            @registerPartials()
            @registerTemplates()

        registerComponent: (id, component) ->
            componentViews[id] = component

        getComponentView: (id) ->
            return unless id of componentViews

            component = componentViews[id]

            unless component.instance
                attributes = {}
                {instance, type} = @model.getComponent id
                attributes[type] = instance
                view = new component.klass attributes
                @$el.append view.el
                component.instance = view

            component.instance

        renderActiveComponent: (model, component) ->
            view = @getComponentView component
            previousComponent = @model.previous 'activeComponent'
            if previousComponent?
                previousView = @getComponentView previousComponent
                previousView.$el.hide()
            view.$el.show()
            view.render()

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
            @model.get('templates').set templates: templates

    ApplicationView
