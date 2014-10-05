var gulp = require('gulp'),
    kraken = require('gulp-kraken');

gulp.task('kraken', function () {
    gulp.src('public/images/**/*.*')
        .pipe(kraken({
            key: '3364c641e11464c0480171eedf2c2cba',
            secret: 'd33f1ca8f6d03c059156470096fde10f62b5485e',
            lossy: true
        }));
});

gulp.task('default', function() {
    gulp.start('kraken');
});