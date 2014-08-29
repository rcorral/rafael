define 'PortfolioView', ->

    class PortfolioView extends Backbone.View

        className: 'app-portfolio'

        initialize: ->
            templates = @collection.templates.get('templates')
            @constructor.template = templates['portfolios-index'].template

        render: ->
            @$el.append @constructor.template portfolios: @collection.toJSON()

    PortfolioView
