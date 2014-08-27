define 'PortfolioCollection',
['PortfolioModel'],
(PortfolioModel) ->

    class PortfolioCollection extends Backbone.Collection

        model: PortfolioModel

        initialize: (models, options) ->
            @loadTemplates options.templates.get 'templates'

        loadTemplates: (templates) ->
            regex = new RegExp /^portfolio-/
            models = []
            for name,template of templates
                continue unless regex.test name
                models.push _.merge template, id: name

            @add models

    PortfolioCollection
