###
Author Marek Pietrucha
https://github.com/mareczek/international-phone-number
###

"use strict"
angular.module("internationalPhoneNumber", []).directive 'internationalPhoneNumber', () ->

  restrict:   'A'
  require: '^ngModel'
  scope: {
    ngModel: '=',
    options: '=internationalPhoneNumber'
  }

  link: (scope, element, attrs, ctrl) ->

    read = () ->
      ctrl.$setViewValue element.val()

    handleWhatsSupposedToBeAnArray = (value) ->
      if value instanceof Array
        value
      else
        value.toString().replace(/[ ]/g, '').split(',')

    # Wait for ngModel to be set
    watchOnce = scope.$watch('ngModel', (newValue) ->
      # Wait to see if other scope variables were set at the same time
      scope.$$postDigest ->
        if newValue != null and newValue != undefined and newValue != ''
          element.val newValue
        
        element.intlTelInput(scope.options)

        unless scope.options.skipUtilScriptDownload != undefined || scope.options.utilsScript
          element.intlTelInput('loadUtils', '/bower_components/intl-tel-input/lib/libphonenumber/build/utils.js')
      
        watchOnce()

    )

    ctrl.$parsers.push (value) ->
      return value if !value
      value.replace(/[^\d]/g, '')

    ctrl.$parsers.push (value) ->
      if value
        validity = element.intlTelInput("isValidNumber")
        ctrl.$setValidity 'international-phone-number', validity
      else
        value = ''
        ctrl.$setValidity 'international-phone-number', true
      value

    element.on 'blur keyup change', (event) ->
      scope.$apply read

    element.on '$destroy', () ->
      element.off 'blur keyup change'
