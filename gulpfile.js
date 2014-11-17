'use strict';

var gulp = require('gulp'),
    autoprefixer = require('gulp-autoprefixer'),
    browserify = require('browserify'),
    clean = require('gulp-clean'),
    concat = require('gulp-concat'),
    coffee = require('coffee-script'),
    debug = require('debug')('debug'),
    debugError = require('debug')('error'),
    es = require('event-stream'),
    gzip = require('gulp-gzip'),
    jadeify = require('jadeify'),
    kraken = require('gulp-kraken'),
    minifyCSS = require('gulp-minify-css'),
    order = require('gulp-order'),
    refresh = require('gulp-livereload'),
    rename = require('gulp-rename'),
    rev = require('gulp-rev'),
    spawn = require('child_process').spawn,
    stylus = require('gulp-stylus'),
    through = require('through'),
    transform = require('vinyl-transform'),
    uglify = require('gulp-uglify');

var livereloadport = 35729,
    inProduction = process.env.NODE_ENV === 'production';

gulp.task('kraken', function () {
    gulp.src('public/images/**/*.*')
        .pipe(kraken({
            key: '3364c641e11464c0480171eedf2c2cba',
            secret: 'd33f1ca8f6d03c059156470096fde10f62b5485e',
            lossy: true
        }));
});

gulp.task('clean-css', function() {
    debug('clean-css');
    gulp.src(['public/assets/*.css', 'public/assets/*.css*.gz'], {read: false})
        .pipe(clean());
});

gulp.task('compile-css', ['clean-css'], function() {
    debug('stylus');
    var deps = gulp.src('node_modules/bootstrap/dist/css/bootstrap.min.css');
    var assets = gulp.src('assets/index.styl')
            .pipe(stylus())
            .pipe(autoprefixer(['> 1%', 'last 2 versions']))
            // Reorder -webkit-flex prefix so it works in mobile.
            .pipe(transform(function(filename) {
                var data = '';
                return through(write, end);

                function write(buf) {data += buf}
                function end() {
                    data = data.replace(/(display: -webkit-flex;)(\s+)(display: -webkit-box;)/g, '$3$2$1');
                    this.emit('data', data);
                    this.emit('end');
                }
            }));
    // Merge both streams
    var bundle = es.merge(deps, assets)
        .pipe(order([
            'node_modules/bootstrap/dist/css/bootstrap.min.css',
            'assets/index.styl'
            ]))
        .pipe(concat('bundle.css'));
    if (inProduction) {
        bundle.pipe(minifyCSS({keepSpecialComments: 0}))
    }
    bundle.pipe(gulp.dest('./public/assets/'));
    if (inProduction) {
        bundle.pipe(gzip())
            .pipe(gulp.dest('./public/assets'));
    }
});

gulp.task('clean-js', function() {
    debug('clean-js');
    gulp.src(['public/assets/*.js', 'public/assets/*.js*.gz'], {read: false})
        .pipe(clean());
});

gulp.task('compile-js', ['clean-js'], function(done) {
    debug('compile-js');
    var browserified = transform(function(filename) {
        var b = browserify(filename);
        b.transform(jadeify);
        b.transform(function (file) {
            var data = '';
            return through(write, end);

            function write (buf) { data += buf }
            function end () {
                if (/\.jade$/.test(file)) {
                    this.queue(data);
                } else {
                    // Remove certain requires
                    data = data.replace(/Backbone\s+=\s+require\s?\(?'backbone'\)?/, '');
                    this.queue(coffee.compile(data));
                }
                this.queue(null);
            }
        });
        return b.bundle()
            .on('error', function(err){
                // print the error (can replace with gulp-util)
                debugError(err.message);
                // end this stream
                this.end();
            });
    });

    // vendor.js
    var vendor = gulp.src([
        './node_modules/jquery/dist/jquery.js',
        './node_modules/underscore/underscore.js',
        './node_modules/backbone/backbone.js',
        './node_modules/bootstrap/dist/js/bootstrap.js',
        './lib/jquery/*.*',
        './lib/highlight.js/highlight.pack.js'
        ])
        .pipe(concat('vendor.js'));
    if (inProduction) {
        vendor.pipe(uglify());
    }
    vendor.pipe(gulp.dest('./public/assets'));
    if (inProduction) {
        vendor.pipe(gzip())
            .pipe(gulp.dest('./public/assets'));
    }

    // bundle.js
    var bundle = gulp.src(['./assets/index.coffee'])
        .pipe(browserified)
        .pipe(rename('bundle.js'));
    if (inProduction) {
        bundle.pipe(uglify());
    }
    bundle.pipe(gulp.dest('./public/assets'));
    if (inProduction) {
        bundle.pipe(gzip())
            .pipe(gulp.dest('./public/assets'));
    }
    bundle.on('end', function() {
        // There's some weird timing issue where the file isn't fully written
        // by the time we get to the 'revision' task
        setTimeout(done, 500);
    });
});

gulp.task('revision', ['compile-css', 'compile-js'], function() {
    debug('revision');
    gulp.src([
        'public/assets/*.css', 'public/assets/*.css.gz',
        'public/assets/*.js', 'public/assets/*.js.gz'
        ])
        .pipe(rev())
        .pipe(gulp.dest('public/assets'))
        .pipe(rev.manifest())
        .pipe(gulp.dest('public/assets'));
});

gulp.task('compile', ['compile-css', 'compile-js', 'revision']);

gulp.task('watch', ['compile'], function() {
    refresh.listen(livereloadport);
    // Watch our scripts, and when they change run browserify
    gulp.watch([
        'apps/**/client.coffee',
        'apps/**/client/*.coffee',
        'apps/**/*.styl',
        'apps/**/*.jade',
        'assets/**/*.coffee',
        'assets/**/*.styl',
        'components/**/*.coffee',
        'collections/**/*.coffee',
        'components/**/*.styl',
        'components/**/*.jade',
        'models/**/*.coffee'
        ], ['compile']);
    gulp.watch('public/assets/bundle.*').on('change', refresh.changed);
});

gulp.task('auto-reload', ['watch'], function() {
    var p;

    gulp.watch([
        'apps/**/*.coffee',
        'apps/**/*.jade',
        'collections/**/*.*',
        'lib/**/*.*',
        'models/**/*.*',
        'components/**/*.coffee',
        'components/**/*.jade'
        ], spawnChildren);
    spawnChildren();

    function spawnChildren(e) {
        // kill previous spawned process
        if(p) {p.kill();}

        // `spawn` a child `gulp` process linked to the parent `stdio`
        p = spawn('bin/www', [], {
            stdio: 'inherit',
            env: {
                DEBUG: 'debug,server,error',
                NODE_PATH: './lib',
                NODE_ENV: 'development',
                NODE_PORT: 3010,
                NODE_HOST: 'localhost',
                NODE_LIVERELOAD_PORT: livereloadport
            }
        });
    }
});

gulp.task('deploy', ['kraken']);

gulp.task('default', []);
