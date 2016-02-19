"use strict"

!function() {
  var _     = require('lodash')
  var iconv = require('iconv-lite')
  var fs    = require('fs')

  var convertTo = _.curryRight(iconv.encode)
  var converters = {
    iso: convertTo('ISO-8859-1', {}),
    utf8: convertTo('UTF-8', {})
  }

  // extra points for that right-hand curry :D

  if (typeof process.argv[2] === "undefined") {
    console.log("You must supply a string.")
    return process.exit()
  }
  
  var iso, utf8, utf16
  var input = process.argv[2]
  var log = console.log 
  
  log("Our input:\t",  input, " Length: ", input.length)

  _.each(converters, function(converter, i) {
    var buf = converter(input)

    log("In: ", i)
    log(" Bytes: ", buf)
    log(" Length: ", buf.length)

    fs.writeFileSync('test' + i + '.txt', buf, 'binary')
  })
}()
