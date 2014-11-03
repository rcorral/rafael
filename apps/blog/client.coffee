appLocals = require '../../lib/app-locals.coffee'

class AboutView extends Backbone.View

    className: 'app-about'

    events:
        'click [data-behavior~=paginate]': 'handlePaginationClick'

    initialize: ->
        @constructor.template = require './templates/index.jade'

        @listenTo @collection, 'sync', @render

    render: ->
        @$el.html @constructor.template @collection.forTemplate()

    handlePaginationClick: ->
        

module.exports = AboutView
