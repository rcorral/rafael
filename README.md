rafael
======

[![Build Status](http://img.shields.io/travis/rcorral/rafael.svg?style=flat)](https://travis-ci.org/rcorral/rafael)
[![dependency Status](https://david-dm.org/rcorral/rafael.svg?style=flat)](https://david-dm.org/rcorral/rafael#info=dependencies)
[![devDependency Status](https://david-dm.org/rcorral/rafael/dev-status.svg?style=flat)](https://david-dm.org/rcorral/rafael#info=devDependencies)

An isomorphic app, which takes some ideologies from [Ezel](https://github.com/artsy/ezel/). It leverages Browserify and shares code between the server and the browser. It's also my own [personal website](http://rafaelcorral.com/).  
It's a single page application, but the requested page will render server-side so we get the benefits of SEO and for performance.

Install
-------
* `$ npm install -g gulp`
* `$ npm install [--production]`
* Install [Redis](http://redis.io/)

Use in development
------------------

1. Start redis `$ redis-server`
2. Compile blog posts `$ npm run-script build-posts`
3. Start server `$ gulp auto-reload`
4. Visit [http://localhost:3010/](http://localhost:3010/)

Use in production
-----------------

1. Install [PM2](https://github.com/Unitech/pm2)
2. Start redis `$ redis-server`
3. Compile blog posts `$ npm run-script build-posts`
4. Start the server  
    `NODE_ENV=production gulp compile && pm2 start processes/prod.json -i max`

Test
----

**Redis must be running**

`$ npm test`

Test coverage is low, but I'm working on it.

Blogging
--------

See the blog app `apps/blog/`, for more information on writing posts and populating Redis.

License
-------

MIT
