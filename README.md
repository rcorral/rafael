rafael
======

An isomorphic app, which takes some ideologies from [Ezel](https://github.com/artsy/ezel/). It leverages Browserify and shares code between the server and the browser. It's also my own [personal website](http://rafaelcorral.com/).  
It's a single page application, but the requested page will render server-side so we get the benefits of SEO. 

Install
-------
* npm install -g gulp
* npm install [--production]

Run
---

### Running in development

`$ gulp auto-reload`

### Running in production

`NODE_ENV=production gulp compile && pm2 start processes/prod.json -i max`

Tests
-----

`$ npm test`

Test coverage is low, but I'm working on it.
