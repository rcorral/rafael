rafael
======

[![Build Status](http://img.shields.io/travis/rcorral/rafael.svg?style=flat)](https://travis-ci.org/rcorral/rafael)
[![dependency Status](https://david-dm.org/rcorral/rafael.svg?style=flat)](https://david-dm.org/rcorral/rafael#info=dependencies)
[![devDependency Status](https://david-dm.org/rcorral/rafael/dev-status.svg?style=flat)](https://david-dm.org/rcorral/rafael#info=devDependencies)

An isomorphic app, which takes some ideologies from [Ezel](https://github.com/artsy/ezel/). It leverages Browserify and shares code between the server and the browser. It's also my own [personal website](http://rafaelcorral.com/).  
It's a single page application, but the requested page will render server-side so we get the benefits of SEO and for performance.

Install
-------
* npm install -g gulp
* npm install [--production]
* install [Redis](http://redis.io/)

Starting the server
-------------------

### Start redis
`$ redis-server`

### Running in development

`$ gulp auto-reload`

### Running in production

`NODE_ENV=production gulp compile && pm2 start processes/prod.json -i max`

Tests
-----

**Redis must be running**

`$ npm test`

Test coverage is low, but I'm working on it.
