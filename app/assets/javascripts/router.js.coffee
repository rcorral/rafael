define 'Router', ->

    class Router extends Backbone.Router

        routes:
            '': 'portfolio'

        portfolio: ->
            @trigger 'navigate:portfolio'

    Router
