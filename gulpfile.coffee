# Utilities
gulp = require("gulp")
gutil = require("gulp-util")
gulpif = require('gulp-if')
rimraf = require("gulp-rimraf")
concat = require("gulp-concat")
coffee = require("gulp-coffee")
uglify = require("gulp-uglify")
minifyCSS = require("gulp-minify-css")
ngAnnotate = require('gulp-ng-annotate')
sass = require("gulp-ruby-sass")
rename = require("gulp-rename")
notify = require("gulp-notify")

packageFileName = 'qdate'

gulp.task "scripts", ->
  gulp.src(["src/js/q_date_init.coffee", "src/js/**/*.coffee"])
    .pipe(
      coffee({bare:true})
        .on('error', notify.onError((error) ->
          "Coffee Compilation Error: #{error.message}"
        ))
        .on('error', gutil.log)
    )
    .pipe(ngAnnotate())
    .pipe(concat("#{packageFileName}.js"))
    .pipe(gulp.dest("dist"))
    .pipe(uglify())
    .pipe(concat("#{packageFileName}.min.js"))
    .pipe(gulp.dest("dist"))

gulp.task "styles", ->
  sassFiles = gulp.src("src/css/*.scss")
    .pipe(sass({
        sourcemap: false,
        unixNewlines: true,
        style: 'nested',
        debugInfo: false,
        quiet: false,
        lineNumbers: true,
        bundleExec: true
      })
      .on('error', gutil.log))
      .on('error', notify.onError((error) ->
        return "SCSS Compilation Error: " + error.message
      ))
  sassFiles
    .pipe(rename({prefix: "#{packageFileName}-"}))
    .pipe(gulp.dest("dist"))

  sassFiles
    .pipe(minifyCSS())
    .pipe(rename({extname: ".min.css"}))
    .pipe(gulp.dest("dist"))

gulp.task "clean", ->
  return gulp.src(["dist"], {read: false})
    .pipe(rimraf({force: true}))

gulp.task 'watch', ->
  gulp.watch('src/**/*.*', ['scripts', 'styles'])

gulp.task "compile", ["clean"], ->
  gulp.start("scripts", "styles")

gulp.task "default", ["clean"], ->
  gulp.start("scripts", "styles", "watch")
