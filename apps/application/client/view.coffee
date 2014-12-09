NavbarView = require '../../../components/navbar/client.coffee'
FooterView = require '../../../components/footer/client.coffee'
AboutView = require '../../about/client.coffee'
PostsView = require '../../blog/client/posts.coffee'
PostView = require '../../blog/client/post.coffee'
HomeView = require '../../home/client.coffee'
PortfolioView = require '../../portfolio/client/index.coffee'
Util = require '../../../components/Util/index.coffee'

componentViews = {}

class ApplicationView extends Backbone.View

    initialize: ->
        router = @model.get 'router'
        @$componentsContainer = $ '.components-container'
        @$body = $ 'body'
        @$footer = $ 'footer'
        @originalTitle = $('title').html()
        @appRendered = false

        @registerComponent 'about',
            klass: AboutView

        @registerComponent 'blog',
            klass: PostsView
            options: {router}

        @registerComponent 'blogPost',
            klass: PostView
            options: {router}

        @registerComponent 'home',
            klass: HomeView
            options: {router}

        @registerComponent 'portfolio',
            klass: PortfolioView

        @navbarView = new NavbarView
            el: $ 'header'
            router: router
            model: @model

        @footerView = new FooterView
            el: $ 'footer'
            model: @model

        # Listeners
        @listenTo @model, 'change:activeComponent', @renderActiveComponent
        @listenTo @model, 'change:title', @handleTitleChange
        @listenToOnce router, 'route', (destination) ->
            $('.site-intro').hide() if destination isnt 'home'
        $(window).on 'resize-end', @handleWindowResize.bind @

    ###
    # Event Handlers
    ###

    handleTitleChange: (model, title) ->
        $('title').html "#{if title is 'Home' then '' else "#{title} – "}#{@originalTitle}"

    handleWindowResize: (e, windowSize) ->
        @updateComponentContainerHeight windowSize

    ###
    # Rendering
    ###

    render: ->
        @navbarView.render()
        @footerView.render()
        @updateComponentContainerHeight()

    ###
    # Helpers
    ###

    updateComponentContainerHeight: (windowSize) ->
        windowSize = @$body.outerHeight true unless windowSize
        minHeight = windowSize - $('header nav').outerHeight(true) - @$footer.outerHeight(true)
        @$componentsContainer.css 'min-height', minHeight

    registerComponent: (id, component) ->
        componentViews[id] = component

    getComponentView: (id) ->
        return unless id of componentViews

        component = componentViews[id]

        unless component.instance
            # Clears out server rendered app
            unless @appRendered
                @$el.empty()
                @appRendered = true

            _.defaults component,
                options: {}
            {instance, type} = @model.getComponent id
            component.options[type] = instance
            view = new component.klass component.options
            @$el.append view.el
            component.instance = view

        component.instance

    renderActiveComponent: (model, component) ->
        previousComponentID = @model.previous 'activeComponent'
        if previousComponentID?
            previousView = @getComponentView previousComponentID
            previousView.$el.hide()
            className = "#{previousView.componentClassName ? previousComponentID}-component"
            @$body.removeClass className

        view = @getComponentView component
        @$body.addClass "#{view.componentClassName ? component}-component"
        view.$el.show()
        view.render()
        Util.scrollToTop() if previousComponentID?

module.exports = ApplicationView
