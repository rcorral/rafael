define 'PortfolioView', ->

    class PortfolioView extends Backbone.View

        className: 'app-portfolio'

        events:
            'click .item-full .close': 'handleClose'
            'click .portfolio-item': 'handleProjectClick'
            'mouseenter .portfolio-item': 'handleProjectMouseEnter'
            'mouseleave .portfolio-item': 'handleProjectMouseLeave'

        initialize: ->
            templates = @collection.templates.get('templates')
            @constructor.template = templates['portfolios-index'].template
            @isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test navigator.userAgent

        render: ->
            @$el.html @constructor.template portfolios: @collection.toJSON()

            @lastWindowPosition = 0
            outer_divs = jQuery '.portfolio-wrapper .outer'
            polaroid_imgs = outer_divs.find '.portfolio-item img'
            polaroid_imgs_counter = 0

            recalculate_height = ->
                tallest_outer = 0
                outer_divs.css height: 'auto'
                outer_divs.each ->
                    curr_height = jQuery(this).outerHeight(true)
                    tallest_outer = curr_height if tallest_outer < curr_height
                outer_divs.css height: "#{tallest_outer}px"

            # Give all outer items the same height
            recalculate_height()

            # Reset the height when all images have loaded
            polaroid_imgs.load ->
                polaroid_imgs_counter++
                if polaroid_imgs.get().length is polaroid_imgs_counter
                    recalculate_height()

        ###
        # Handlers
        ###

        handleProjectClick: (e) ->
            $el = jQuery e.currentTarget
            $outer_parent = $el.parents '.outer'
            ypos = _ypos = @getYPos $outer_parent.get 0
            found = false
            last = jQuery.extend {}, $outer_parent
            $prev_items = jQuery '.portfolio-wrapper .item-full'
            @lastWindowPosition = @winYPos()
            scrollOffset = if @isMobile then 20 else 345

            # Find the next item that has a different y pos
            # The max length is 3 so no need for more than that
            for i in [1...4]
                next = last.next()

                break if !next.get 0

                _ypos = @getYPos next.get 0

                if ypos != _ypos
                    found = true
                    break

                last = next
                next = next.next()

            # Slideup any previous content
            jQuery('.outer .arrow-up').remove()
            $prev_items.removeClass('item-full').hide().remove()

            # Add item next to last element
            last.after '<div class="item-full" style="display:none;">' +$el.next().html()+ '</div>'
            $new_items = jQuery '.portfolio-wrapper .item-full'
            $image_div = $new_items.find '.item-more div.images'
            $restOfImages = $image_div.find 'img:not(:first-child)'
            $restOfImages.hide()
            $new_items.slideDown 1000, -> $restOfImages.show()

            # Init the slideshow
            $image_div.slideshow scrollToOffset: scrollOffset

            # Scrolling won't happen from plugin unless there are images, so do manually
            if 0 is $image_div.length
                setTimeout ->
                    $new_items.smoothScroll scrollOffset
                , 300

            # Add arrow
            arrow = @createElement 'i', '', class: 'fa fa-caret-up arrow-up'
            $outer_parent.append arrow

        handleProjectMouseEnter: (e) ->
            jQuery(e.currentTarget).fadeTo 'fast', 1

        handleProjectMouseLeave: (e) ->
            jQuery(e.currentTarget).fadeTo 'fast', .90

        handleClose: (e) ->
            jQuery('.outer .arrow-up').remove()
            jQuery(e.currentTarget).parent().slideUp 800, -> jQuery(this).remove()
            jQuery('html, body').animate
                'scrollTop': @lastWindowPosition
            , 'slow', 'swing'

        ###
        # Helpers
        ###

        getYPos: (el) ->
            ly = 0
            while el?
                ly += el.offsetTop
                el = el.offsetParent
            ly

        winYPos: ->
            if typeof window.pageYOffset isnt 'undefined'
                window.pageYOffset
            else if document.documentElement and document.documentElement.scrollTop
                document.documentElement.scrollTop
            else if document.body.scrollTop
                document.body.scrollTop
            else
                0

        createElement: (type, html, attribs) ->
            element = document.createElement type

            for i of attribs
                element.setAttribute i, attribs[i]

            element.innerHTML = html if html
            element

    PortfolioView
