Util = require '../../../components/Util/index.coffee'

module.exports = class PostView extends Backbone.View

    className: 'app-blog-post blog'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/post.jade'

        @listenTo @model, 'sync', @render

    render: ->
        @$el.html @constructor.template @model.toJSON()
        Util.scrollToTop()
