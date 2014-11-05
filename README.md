# qDate for Angular.js

qDate is a lean set of date/time directives for Angular.js. It consists of a date picker, a time picker, a date picker popup, and a date/time picker popup.

# Status

This is alpha software and has, so far, only been tested in Chrome.

# Installation:

From the `dist` directory, add 1 js file and 1 css file to your project. Bower support coming soon.


Next, add the `"q-date"` module as a dependency in your angular application.

# Usage:

**Note:** Each of these directives requires an `ng-model` attribute, which is set to null or a date object.

## Inline Date Picker

```html
<q-calendar ng-model='myDate'></q-calendar>
```

**Options:**

* `date-filter`: Pass in the name of a function that will determine whether or not a given date will be enabled in the calendar.
* `close-on-select`: Close the popup as soon as a date is clicked. Defaults to true.

## Time Picker

Simple timepicker that uses 2-3 select lists.

```html
<q-timepicker ng-model='myDate' am-pm='true'></q-timepicker>
```

**Options:**

* `am-pm`: Defaults to using AM-PM formatted times, but you can use 24-hour mode by setting this option to false.

## Date Picker Popup

Attach this to any element and, upon click or focus, a popup with a calendar will appear.

**Button Example:**
```html
<button ng-model='myDate' q-datepicker-popup ng-bind="myDate | date:'shortDate'"></button>
```

**Options:**

* `date-filter`: Pass in the name of a function that will determine whether or not a given date will be enabled in the calendar.

**Input Example:**
```html
<input type='text' ng-model='myDate' q-datepicker-popup date-parser='short'/>

```

**Note:** If you would like to use an input field like this, I recommend using the [angular-date-parser library](https://github.com/dnasir/angular-dateParser), as I have done above. This will allow the user to enter formatted dates and convert them to date objects using [Angular's date filter syntax](https://docs.angularjs.org/api/ng/filter/date).

## Date / Time Picker Popup

This will do the same as the datepicker popup, but add a timepicker below it.

```html
<button ng-model='myDate' q-datetimepicker-popup ng-bind="myDate | date:'short'"></button>
```


**Options:**

* `date-filter`: Pass in the name of a function that will determine whether or not a given date will be enabled in the calendar.
* `am-pm`: Defaults to AM-PM, but you can use 24-hour mode by setting this option to false.


## Contributing

Contributions are welcome. Whenever possible, please include test coverage with your contribution.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

To get the project running, you'll need [NPM](https://npmjs.org/) and [Bower](http://bower.io/). Run `npm install` and `bower install` to install all dependencies. Then run `gulp` in the project directory to watch and compile changes. And you can run `npm run test` to watch for changes and auto-execute unit tests.


