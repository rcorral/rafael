class Router extends Backbone.Router

    routes:
        '': 'home'
        'about': 'about'
        'blog': 'blog'
        'portfolio': 'portfolio'

    initialize: ->
        @on 'all', @doRoute

    doRoute: (action, route) ->
        return unless action is 'route'
        @trigger "navigate:#{route}", route

module.exports = Router
