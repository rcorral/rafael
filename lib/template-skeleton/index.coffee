_ = require 'underscore'
appLocals = require 'app-locals'
assets = require '../../public/assets/rev-manifest.json'
jade = require 'jade'
path = require 'path'
sd = require('sharify').data

proxyPort = process.env.NODE_PROXYPORT|0
navbarPath = path.join __dirname, '../../components/navbar/navbar.jade'
navbarView = jade.compileFile navbarPath
footerPath = path.join __dirname, '../../components/footer/footer.jade'
footerView = jade.compileFile footerPath

# @return  {js: [], css: []} formatted assets
parseAssets = (assets, gzip) ->
    if sd.ENV is 'development'
        css = ['bundle.css']
        js = ['vendor.js', 'bundle.js']
    else
        if gzip
            css = [assets['bundle.css.gz']]
            js = [assets['vendor.js.gz'], assets['bundle.js.gz']]
        else
            css = [assets['bundle.css']]
            js = [assets['vendor.js'], assets['bundle.js']]

    {css, js}

module.exports =

    register: (app) ->
        app.set 'views', __dirname + '/templates'
        app.set 'view engine', 'jade'

    render: (req, res, opts) ->
        res.removeHeader 'x-powered-by' # credit will be given elsewhere
        res.render 'index', _.defaults {}, appLocals, opts,
            appName: ''
            assets: parseAssets assets, req.acceptsEncodings('gzip')
            description: 'Full stack engineer in San Francisco. Known language: JS, PHP, CSS, HTML, SQL, NoSQL'
            footerView: footerView appLocals
            hasNav: true
            inProduction: sd.ENV is 'production'
            navbarView: navbarView opts.navbarOpts
            title: 'Rafael Corral'
