define 'Util', ->

    Util =

        capitalize: (str) ->
            str.replace /(^\s*)(\S)(.*)$/g, (match, whitespace, firstLetter, rest) ->
                 whitespace + firstLetter.toUpperCase() + rest

    Util
