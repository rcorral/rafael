using 'ApplicationModel', 'ApplicationView', 'Router',
(ApplicationModel, ApplicationView, Router) ->

    model = new ApplicationModel
        router: new Router()

    view = new ApplicationView
        model: model
        el: $ '.app-wrapper'

    model.start()
