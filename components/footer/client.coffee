Util = require '../Util/index.coffee'

class FooterView extends Backbone.View

    events:
        'click [data-behavior~=outbound]': 'handleOutboundClick'

    initialize: (options) ->
        @model = options.model
        @listenTo @model, 'change:activeComponent', @render
        @renderCount = -1

    handleOutboundClick: (e) ->
        @undelegateEvents()
        e.preventDefault()
        $el = $ e.currentTarget
        url = Backbone.history.getFragment()
        Util.trackEvent $el.data('behavior'), 'click', $el.data('label'), page: "/#{url}"
        setTimeout ->
            $(e.target).click()
        , 500

    render: ->
        activeComponent = @model.get 'activeComponent'

        if @renderCount is 0 and activeComponent is 'home'
            @$el.hide()
        else
            @$el.show()

        @renderCount++

module.exports = FooterView
