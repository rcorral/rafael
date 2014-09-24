define 'FooterView', ->

    class FooterView extends Backbone.View

        initialize: (options) ->
            @model = options.model
            @listenTo @model, 'change:activeComponent', @render
            @renderCount = -1

        render: ->
            activeComponent = @model.get 'activeComponent'

            if @renderCount is 0 and activeComponent is 'home'
                @$el.hide()
            else
                @$el.show()

            @renderCount++

    FooterView
