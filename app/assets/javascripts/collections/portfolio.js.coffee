define 'PortfolioCollection',
['PortfolioModel'],
(PortfolioModel) ->

    class PortfolioCollection extends Backbone.Collection

        model: PortfolioModel

        initialize: (models, options) ->
            @templates = options.templates
            @comparator = (a, b) ->
                _a = a.get('sort')|0
                _b = b.get('sort')|0
                if _a is _b
                    0
                else if _a > _b
                    -1
                else if _a < _b
                    1
            @loadTemplates @templates.get 'templates'

        loadTemplates: (templates) ->
            regex = new RegExp /^portfolio-/
            models = []
            for name,template of templates
                continue unless regex.test name
                models.push _.merge template, id: name

            @add models

    PortfolioCollection
