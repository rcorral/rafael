class Router extends Backbone.Router

    routes:
        '': 'home'
        'portfolio': 'portfolio'
        'about': 'about'

    initialize: ->
        @on 'all', @doRoute

    doRoute: (action, route) ->
        return unless action is 'route'
        @trigger "navigate:#{route}", route

module.exports = Router
