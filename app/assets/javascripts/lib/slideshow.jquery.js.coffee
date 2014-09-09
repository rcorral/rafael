###
# Image slideshow
# By Rafael Corral
###
do (
    $=jQuery
) ->
    $.fn.slideshow = (options) ->
        options = $.extend
            scrollTo: true,
            scrollToOffset: 0,
            btnmobile: 'btn-mobile',
            imgHeightOffset: 31
        , options
        is_mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)

        @each ->
            $this = $ @
            $inner = $this.find '.inner-wrap'
            $images = $inner.find 'img'
            $current = $ $images[0]
            is_moving = false
            move = ->

            # Set some basics stuff
            $images.addClass('img-polaroid')
            $current.addClass('current')
            $this.css
                height: $current.outerHeight true
                'max-width': $current.outerWidth true

            if options.scrollTo
                setTimeout ->
                    $this.smoothScroll options.scrollToOffset
                , 500

            size = ->
                width = $this.parents('.item-full').width()
                $current = $inner.find 'img.current'
                styles_width = $current.outerWidth(true) - $current.width()

                $images.css 'max-width': width - styles_width
                $this.css
                    height: $current.outerHeight(true) + options.imgHeightOffset,
                    'max-width': $current.outerWidth true

                $inner.css eft: -$current.get(0).offsetLeft

            # Window listeners
            $(window)
                .unbind 'resize.ss'
                .unbind 'keydown.ss'
                .on 'resize.ss',  ->
                    images = $ '.item-full .item-more .images'
                    images.each ->
                        size()
                .on 'keydown.ss', (e) ->
                    key = e.keyCode
                    if 37 == key
                        move 'left'
                    else if 39 == key
                        move 'right'

            # Let's make sure there are at least two images before we do the rest
            if $images.length < 2
                size()
                return this

            # Touch listeners
            $this
                .unbind 'swipeleft.ss'
                .unbind 'swiperight.ss'
                .on 'swipeleft.ss',  ->
                    move 'right'
                .on 'swiperight.ss',  ->
                    move 'left'

            # Add buttons
            mblclass = " #{options.btnmobile}"
            lbtn = createElement 'i', '',
                class: "btn btn-larg btnl#{mblclass} fa fa-chevron-circle-left"
                'data-direction': 'left'
            rbtn = createElement 'i', '',
                class: "btn btn-larg btnr#{mblclass} fa fa-chevron-circle-right"
                'data-direction': 'right'
            $this.prepend lbtn, rbtn

            # Listeners for btns
            $(lbtn).add(rbtn).click ->
                $that = $ this
                direction = $that.data 'direction'
                move direction

            move = (direction) ->
                if is_moving
                    # Wait a bit and try again
                    setTimeout ->
                        move direction
                    , 300
                    return

                is_moving = true

                # Find current image
                $current = $this.find '.current'

                if 'right' == direction
                    $next = $current.next()
                    if !$next.get 0
                        # This means we need the first one
                        $next = $this.find 'img:first'

                        # Move to last position
                        $inner.css
                            left: parseFloat($inner.get(0).offsetLeft) + $next.outerWidth(true)
                        $next.appendTo($inner)

                    $this.animate
                        height: $next.outerHeight(true) + options.imgHeightOffset,
                        'max-width': $next.outerWidth(true)

                    $inner.animate
                        left: parseFloat($inner.get(0).offsetLeft) - $current.outerWidth(true)
                    , ->
                        is_moving = false
                else
                    $next = $current.prev()
                    if !$next.get 0
                        # This means we need the first one
                        $next = $this.find 'img:last'

                        # Move to last position 
                        $inner.css
                            left: parseFloat($inner.get(0).offsetLeft) - $next.outerWidth(true)
                        $next.prependTo $inner

                    $this.animate
                        height: $next.outerHeight(true) + options.imgHeightOffset,
                        'max-width': $next.outerWidth true

                    $inner.animate
                        left: parseFloat($inner.get(0).offsetLeft) + $next.outerWidth(true)
                    , ->
                        is_moving = false

                $current.removeClass 'current'
                $next.addClass 'current'

            # Finally size
            size()

            # Flash buttons to let the user know there are images to swipe through
            if is_mobile
                for i in [0...8]
                    if i % 2
                        setTimeout ->
                            $(lbtn).add(rbtn).hide()
                        , i * 800
                    else
                        setTimeout ->
                            $(lbtn).add(rbtn).show()
                        , i * 800

        this

    # Just animate scroll to element
    $.fn.smoothScroll = (offset) ->
        offset = 0 if typeof offset is undefined

        $('html, body').animate
            'scrollTop': this.offset().top - offset
        , 'slow', 'swing'

        this

    createElement = (type, html, attribs) ->
        element = document.createElement type

        for i of attribs
            element.setAttribute i, attribs[i]

        element.innerHTML = html if html

        element
