# Utilities
gulp = require("gulp")
gutil = require("gulp-util")
gulpif = require('gulp-if')
clean = require("gulp-clean")
concat = require("gulp-concat")
coffee = require("gulp-coffee")
uglify = require("gulp-uglify")
minifyCSS = require("gulp-minify-css")
ngmin = require("gulp-ngmin")
sass = require("gulp-ruby-sass")
rename = require("gulp-rename")
notify = require("gulp-notify")

gulp.task "scripts", ->
  coffeeFiles = gulp.src(["src/js/q_date_init.coffee", "src/js/**/*.coffee"])
    .pipe(
      coffee({bare:true})
        .on('error', notify.onError((error) ->
          "Coffee Compilation Error: #{error.message}"
        ))
        .on('error', gutil.log)
    )
    .pipe(ngmin())

  coffeeFiles
    .pipe(concat("qdate.js"))
    .pipe(gulp.dest("dist"))
  coffeeFiles
    .pipe(uglify())
    .pipe(concat("qdate.min.js"))
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
        return "SCSS Compilation Error: " + error.message;
      ))
  sassFiles
    .pipe(rename({prefix: "qdate-"}))
    .pipe(gulp.dest("dist"))

  sassFiles
    .pipe(minifyCSS())
    .pipe(rename({extname: ".min.css"}))
    .pipe(gulp.dest("dist"))

gulp.task "clean", ->
  return gulp.src(["dist"], {read: false})
    .pipe(clean({force: true}))

gulp.task 'watch', ->
  gulp.watch('src/**/*.*', ['scripts', 'styles'])

gulp.task "compile", ["clean"], ->
  gulp.start("scripts", "styles")

gulp.task "default", ["clean"], ->
  gulp.start("scripts", "styles", "watch")
