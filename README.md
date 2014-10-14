rafael
======

An isomorphic (buzzz) app, which takes some ideologies from Ezel. It leverages Browserify and shares code between the server and the browser. It's also my own [personal website](http://rafaelcorral.com/).  
When loaded it's a single page application, but the first render will load the requested page so we get the benefirst for SEO. 

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

Have yet to write some
