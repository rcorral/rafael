Util = require '../../../components/Util/index.coffee'

module.exports = class PostsView extends Backbone.View

    className: 'app-blog'

    events:
        'click [data-behavior~=paginate]': 'handlePaginationClick'
        'click [data-behavior~=view-post]': 'handleViewPost'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/posts.jade'

        @listenTo @collection, 'sync', @render

    render: ->
        @$el.html @constructor.template @collection.forTemplate()
        Util.scrollToTop()

    handlePaginationClick: (e) ->
        e.preventDefault()
        page = $(e.currentTarget).data 'page'
        @router.navigate @collection.urlForPage(page), trigger: true

    handleViewPost: (e) ->
        e.preventDefault()
        id = $(e.currentTarget).data 'id'
        post = @collection.get id
        @router.navigate post.frontEndUrl(), trigger: true
