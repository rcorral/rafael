parser = require '../lib/post-language.js'

describe 'post-language', ->

    it 'parses strings in single quotes', ->
        parser.parse("title: 'some text'").should.eql title: 'some text'

    it 'parses strings in double quotes', ->
        parser.parse('title: "some text"').should.eql title: 'some text'

    it 'parses datetime', ->
        dateString = '2014-12-11T12:01'
        parser.parse("datetime: #{dateString}").should.eql
            datetime: new Date dateString

    it 'errors with invalid datetime', ->
        dateString = '0000-99-99T99:99'
        do(->parser.parse("datetime: #{dateString}")).should.throw

    it 'parses tag', ->
        parser.parse('tags: ["some tag"]').should.eql
            tags: ['some tag']

    it 'parses tags', ->
        parser.parse('tags: ["some tag", "another tag"]').should.eql
            tags: ['some tag', 'another tag']

    it 'errors when tags aren\'t in a valid JSON format', ->
        do(-> parser.parse("tags: ['some tag', 'another tag']")).should.throw

    it 'parses JADE declaration', ->
        parser.parse("<!-- abstract -->\nJADE\np Some text\nJADE;").should.eql
            abstract: 'p Some text'

    it 'errors with incomplete declaration', ->
        do(-> parser.parse('text: ')).should.throw

    it 'errors with invalid declaration', ->
        do(-> parser.parse('text: unquoted text')).should.throw

    it 'parses a complete document', ->
        dateString = '2014-07-13T20:12'
        content = 'title: "First post"' +
            "date: #{dateString}" +
            'tags: ["hello", "world"]' +
            '<!-- abstract -->' +
            'JADE\n' +
            'p Some text' +
            '\nJADE;' +
            '<!-- post -->' +
            'JADE\n' +
            'p Some longer text' +
            '\nJADE;' +
            'slug: "a slug"'
        parser.parse(content).should.eql
            title: 'First post'
            date: new Date dateString
            tags: ['hello', 'world']
            slug: 'a slug'
            abstract: 'p Some text'
            post: 'p Some longer text'
