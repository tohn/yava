# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$("input#search.span3").click ->
		scanner = cordova.require("cordova/plugin/BarcodeScanner")
		scanner.scan ((result) ->
			alert "We got a barcode\n" + "Result: " + result.text + "\n" + "Format: " + result.format + "\n" + "Cancelled: " + result.cancelled
		), (error) ->
			alert "Scanning failed: " + error
