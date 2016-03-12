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
#   hubot tableflip | tf this - Returns a flipped table of 'arrgh!'!
#   hubot tableflip | tf this <text> - Returns a flipped table of <text>!
#   hubot tableflip | tf <text> - Returns a specific flipped table based on <text> else flips <text>!
#   hubot table_list - Returns a list of flippable tables!
#
# Author:
#   Jarrett Drouillard ( @kuatsure )

TABLEFLIP =
  base_url: 'http://table-flip.herokuapp.com'

FLIPS = [
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

_flipping = ( parts ) ->
  "flipping/#{parts.join ' '}"

_flipIt = ( msg, query, cb ) ->
  url = "#{TABLEFLIP.base_url}/#{query}"

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

module.exports = ( robot ) ->
  robot.respond /table_list/i, ( msg ) ->
    msg.send "You can flip these tables! :v:\n#{FLIPS.join '\n'}"

  robot.respond /t(ableflip|f)( .*)?/i, ( msg ) ->
    _ = require 'lodash'

    if msg.match[2]?
      match = msg.match[2].substring 1
      parts = match.split ' '

      if parts[0] in FLIPS and parts.length is 1
        match = parts[0]

      else if parts[0] is 'this'
        if parts.length > 1
          match = _flipping _.rest parts

        else
          match = _flipping [ 'arrgh!' ]

      else
        match = _flipping parts

    else
      match = msg.random FLIPS

    _flipIt msg, match, ( flippage ) ->
      msg.send flippage
