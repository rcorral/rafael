Backbone = require 'backbone'
Util = require '../../../components/Util/index.coffee'

module.exports = class PostView extends Backbone.View

    className: 'app-blog-post blog'

    componentClassName: 'blog-post'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/post.jade'

        @listenTo @model, 'sync', @render

    render: ->
        @$el.html @constructor.template @model.toJSON()
        @$('pre code').each (i, block) ->
            hljs.highlightBlock block
