class Router extends Backbone.Router

    routes:
        '': 'home'
        'about': 'about'
        'portfolio': 'portfolio'
        'blog': 'blog'
        'blog/page/:page': 'blog'
        'blog/:post': 'blogPost'

    home: -> @trigger 'navigate:home', 'home'

    about: -> @trigger 'navigate:about', 'about'

    portfolio: -> @trigger 'navigate:portfolio', 'portfolio'

    blog: (page=0) ->
        @trigger 'navigate:blog', parseInt page, 10

    blogPost: (post) ->
        @trigger 'navigate:blogPost', post

module.exports = Router
