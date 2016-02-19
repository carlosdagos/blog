"use strict"

!function() {
  var _     = require('lodash')
  var iconv = require('iconv-lite')

  var convertTo        = _.curryRight(iconv.encode)
  var convertToISO8859 = convertTo('ISO-8859-1', {})
  var convertToUTF8    = convertTo('UTF-8', {})
  var convertToUTF16   = convertTo('UTF-16', {})

  // extra points for that right-hand curry :D

  if (typeof process.argv[2] === "undefined") {
    console.log("You must supply a string.")
    return process.exit()
  }
  
  var iso, utf8, utf16
  var input = process.argv[2]
  var log = console.log 

  log("Our input:\t",  input, " Length: ", input.length)
  log("In ISO8859:\t", iso   = convertToISO8859(input), " Length: ", iso.length)
  log("In UTF8:\t",    utf8  = convertToUTF8(input), " Length: ", utf8.length)
  log("In UTF16:\t",   utf16 = convertToUTF16(input), " Length: ", utf16.length)
}()
