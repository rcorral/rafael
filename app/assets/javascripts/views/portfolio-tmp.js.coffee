do ->
    # Preload images after load

    jQuery(document).ready ->
        portfolio_item = jQuery '.portfolio-item'
        last_window_position = 0
        outer_divs = jQuery '.app-portfolio .outer'
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

        portfolio_item.hover ->
                jQuery(this).fadeTo 'fast', 1
        , ->
                jQuery(this).fadeTo 'fast', .90

        # Listener to display more info on item
        portfolio_item.on 'click', (e) ->
            $el = jQuery e.currentTarget
            $outer_parent = $el.parents '.outer'
            ypos = _ypos = get_ypos $outer_parent.get 0
            found = false
            last = jQuery.extend {}, $outer_parent
            $prev_items = jQuery '.app-portfolio .item-full'
            last_window_position = win_ypos()

            # Find the next item that has a different y pos
            # The max length is 3 so no need for more than that
            for i in [1...4]
                next = last.next()

                break if !next.get 0

                _ypos = get_ypos next.get 0

                if ypos != _ypos
                    found = true
                    break

                last = next
                next = next.next()

            # Slideup any previous content
            jQuery('.outer .arrow-up').remove()
            $prev_items.removeClass('item-full').css({height: '50px'}).slideUp 800, ->
                $prev_items.remove()

            # Add item next to last element
            last.after '<div class="item-full" style="display:none;">' +$el.next().html()+ '</div>'
            $new_items = jQuery '.app-portfolio .item-full'
            $image_div = $new_items.find '.item-more div.images'
            $new_items.slideDown 1000
            # Init the slideshow
            $image_div.slideshow scrollToOffset: 20

            # Scrolling won't happen from plugin unless there are images, so do manually
            if 0 is $image_div.length
                setTimeout ->
                    $new_items.smooth_scroll 20
                , 300

            # Add arrow
            arrow = create_element 'div', '', class: 'arrow-up'
            $outer_parent.append arrow

        jQuery('.app-portfolio').on 'click', '.item-full .close', ->
            jQuery('.outer .arrow-up').remove()
            jQuery(this).parent().slideUp 800, -> jQuery(this).remove()
            jQuery('html, body').animate
                'scrollTop': last_window_position
            , 'slow', 'swing'

    get_ypos = (el) ->
        ly = 0
        while el?
            ly += el.offsetTop
            el = el.offsetParent
        ly

    win_ypos = ->
        if typeof window.pageYOffset isnt 'undefined'
            window.pageYOffset
        else if document.documentElement and document.documentElement.scrollTop
            document.documentElement.scrollTop
        else if document.body.scrollTop
            document.body.scrollTop
        else
            0

    create_element = (type, html, attribs) ->
        element = document.createElement type

        for i of attribs
            element.setAttribute i, attribs[i]

        element.innerHTML = html if html
        element

    _alert = (msg) -> console.log msg
