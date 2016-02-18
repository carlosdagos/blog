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

  var input = process.argv[2]

  console.log("Our input:\t",  input)
  console.log("In ISO8859:\t", convertToISO8859(input))
  console.log("In UTF8:\t",    convertToUTF8(input))
  console.log("In UTF16:\t",   convertToUTF16(input))
}()
