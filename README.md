# qDate for Angular.js

qDate is a lean set of date/time directives for Angular.js. It consists of a date picker, a time picker, a date picker popup, and a date/time picker popup.

# Installation:

The lastest version can be downloaded from [here](). You may also install the "q-date" package in [Bower](http://bower.io)

# Usage:

First, add the `"q-date"` module to your application.

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
