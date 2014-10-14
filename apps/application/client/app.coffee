ApplicationModel = require '../model.coffee'
ApplicationView = require './view.coffee'
ApplicationRouter = require './router.coffee'

module.exports.init = ->
    model = new ApplicationModel
        router: new ApplicationRouter()

    view = new ApplicationView
        model: model
        el: $ '.app-wrapper'

    model.start()
    view.render()

    $win = $ window
    $body = $ 'body'

    # Scroll listener
    $win.scroll _.debounce ->
        doc = document.documentElement
        pos = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0)
        $win.trigger 'scroll-end', pos
    , 150, leading: false, trailing: true, maxWait: 150

    # Resize listener
    $win.resize _.debounce ->
        $win.trigger 'resize-end', $body.outerHeight true
    , 150, leading: false, trailing: true, maxWait: 150
