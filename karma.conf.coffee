module.exports = (config) ->
  config.set
    autoWatch: true
    frameworks: ['jasmine']
    browsers: ['PhantomJS']
    preprocessors: {
      '**/*.coffee': ['coffee'],
    }
    coffeePreprocessor: {
      options: {
        bare: true,
        sourceMap: false
      }
      transformPath: (path) -> path.replace(/\.js$/, '.coffee')
    }
    reporters: ['progress', 'osx']
    files: [
      "vendor/bower/jquery/jquery.js"
      "vendor/bower/lodash/dist/lodash.js"
      "vendor/bower/angular/angular.js"
      "vendor/bower/angular-mocks/angular-mocks.js"
      "vendor/browserTrigger.js"
      "src/js/q_date_init.coffee"
      "src/js/**/*.coffee"
      "spec/**/*.coffee"
    ]
