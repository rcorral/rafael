using 'ApplicationModel', 'ApplicationView', 'Router',
(ApplicationModel, ApplicationView, Router) ->

    model = new ApplicationModel
        router: new Router()

    view = new ApplicationView
        model: model
        el: $ '.app-wrapper'

    model.start()
    view.render()

    # Setup scroll listener
    $win = $ window
    $body = $ 'body'
    $win.scroll _.debounce ->
        doc = document.documentElement
        pos = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0)
        $win.trigger 'scroll-end', pos
    , 150, leading: false, trailing: true, maxWait: 150

    $win.resize _.debounce ->
        $win.trigger 'resize-end', $body.outerHeight true
    , 150, leading: false, trailing: true, maxWait: 150
 