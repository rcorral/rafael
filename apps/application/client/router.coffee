sd = require('sharify').data

class Router extends Backbone.Router

    routes:
        '': 'home'
        'about': 'about'
        'portfolio': 'portfolio'
        'blog': 'blog'
        'blog/page/:page': 'blog'
        'blog/:post': 'blogPost'

    initialize: ->
        @on 'all', @_trackPageview if sd.ENV is 'production'

    _trackPageview: (action, route) ->
        return unless action is 'route' # Avoids multiple calls
        url = Backbone.history.getFragment()
        ga = window[window.GoogleAnalyticsObject]
        ga 'send', 'pageview', "/#{url}" if ga

    home: -> @trigger 'navigate:home', 'home'

    about: -> @trigger 'navigate:about', 'about'

    portfolio: -> @trigger 'navigate:portfolio', 'portfolio'

    blog: (page=0) ->
        @trigger 'navigate:blog', parseInt page, 10

    blogPost: (post) ->
        @trigger 'navigate:blogPost', post

module.exports = Router
