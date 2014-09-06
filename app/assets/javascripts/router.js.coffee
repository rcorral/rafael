define 'Router', ->

    class Router extends Backbone.Router

        routes:
            '': 'home'
            'portfolio': 'portfolio'

        home: ->
            @trigger 'navigate:home'

        portfolio: ->
            @trigger 'navigate:portfolio'

    Router
