define 'ApplicationView',
['PortfolioView'],
(PortfolioView) ->

    componentViews = {}

    class ApplicationView extends Backbone.View

        initialize: ->
            @listenTo @model, 'change:activeComponent', @renderActiveComponent

            @registerComponent 'portfolio',
                klass: PortfolioView

        registerComponent: (id, component) ->
            componentViews[id] = component

        getComponentView: (id) ->
            return unless id of componentViews
            component = componentViews[id]
            unless component.instance
                model = @model.getComponent id
                view = new component.klass model: model
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

    ApplicationView
