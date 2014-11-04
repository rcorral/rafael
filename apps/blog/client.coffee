appLocals = require '../../lib/app-locals.coffee'
Util = require '../../components/Util/index.coffee'

class AboutView extends Backbone.View

    className: 'app-about'

    events:
        'click [data-behavior~=paginate]': 'handlePaginationClick'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require './templates/index.jade'

        @listenTo @collection, 'sync', @render

    render: ->
        @$el.html @constructor.template @collection.forTemplate()
        Util.scrollToTop()

    handlePaginationClick: (e) ->
        e.preventDefault()
        page = $(e.currentTarget).data 'page'
        @router.navigate @collection.urlForPage(page), trigger: true

module.exports = AboutView
