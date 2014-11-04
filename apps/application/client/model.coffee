Posts = require '../../../collections/posts.coffee'
sd = require('sharify').data
Util = require '../../../components/Util/index.coffee'

components = {}

class ApplicationModel extends Backbone.Model

    initialize: ->
        router = @get 'router'
        @listenTo router, 'navigate:about', @handleComponent
        @listenTo router, 'navigate:blog', @handleBlog
        @listenTo router, 'navigate:home', @handleComponent
        @listenTo router, 'navigate:portfolio', @handleComponent

        @registerComponent 'about',
            modelKlass: Backbone.Model

        @registerComponent 'blog',
            collectionKlass: Posts
            models: sd.blogPosts
            options:
                page: sd.blogPage
                total: sd.totalPosts

        @registerComponent 'portfolio',
            modelKlass: Backbone.Model

        @registerComponent 'home',
            modelKlass: Backbone.Model

    start: ->
        Backbone.history.start pushState: true

    registerComponent: (id, component) ->
        components[id] = component

    getComponent: (id) ->
        return unless id of components

        component = _.defaults components[id],
            models: null
            attributes: {}
            options: {}

        unless component.instance
            if component.collectionKlass
                klass = component.collectionKlass
                arg1 = component.models
            else
                klass = component.modelKlass
                arg1 = component.attributes

            component.instance = new klass arg1, component.options

        instance: component.instance
        type: if component.collectionKlass then 'collection' else 'model'

    # Renders a component that doesn't need any special treatment
    handleComponent: (component) ->
        {instance} = @getComponent component
        @set
            activeComponent: component
            title: Util.capitalize component

    handleBlog: (page) ->
        @handleComponent 'blog'
        {instance} = @getComponent 'blog'
        if not instance.length or page isnt instance.page
            instance.loadPage page

module.exports = ApplicationModel
