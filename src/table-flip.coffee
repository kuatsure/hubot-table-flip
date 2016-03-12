# Description:
#   Have a hubot flip a table!
#
# Dependencies:
#   Lodash
#
# Configuration:
#   None
#
# Commands:
#   hubot tableflip | tf - Returns a random flipped table!
#   hubot tableflip | tf this <text> - Returns a flipped table of <text>!
#   hubot tableflip | tf <text> - Returns a specific flipped table based on <text> else flips <text>!
#
# Author:
#   Jarrett Drouillard ( @kuatsure )

tableFlip =
  base_url: 'http://table-flip.herokuapp.com'

flips = [
  'flipping'
  'patience'
  'pudgy'
  'battle'
  'me'
  'aggravated'
  'putback'
  'dude'
  'emotional'
  'freakout'
  'hercules'
  'jedi'
  'bear'
  'magical'
  'robot'
  'russia'
  'happy'
]

module.exports = ( robot ) ->
  robot.respond /t(ableflip|f)( .*)?/i, ( msg ) ->
    _ = require 'lodash'

    if msg.match[2]?
      match = msg.match[2].substring 1
      parts = match.split ' '

      if parts[0] in flips and parts.length is 1
        match = parts[0]

      else if parts[0] is 'this'
        if parts.length > 1
          match = _flipping _.rest parts

        else
          match = _flipping [ 'arrgh!' ]

      else
        match = _flipping parts

    else
      match = msg.random flips

    flipIt msg, match, ( flippage ) ->
      msg.send flippage

_flipping = ( parts ) ->
  "flipping/#{parts.join ' '}"

flipIt = ( msg, query, cb ) ->
  url = "#{tableFlip.base_url}/#{query}"

  msg.http( url )
    .get() ( err, res, body ) ->
      response = undefined

      try
        response = body

        cb response

      catch e
        response = undefined

        cb 'Error'

      return if response is undefined
