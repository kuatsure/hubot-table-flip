# Description:
#   Have a hubot flip a table!
#
# Dependencies:
#   Lodash
#
# Configuration:
#   HUBOT_TABLE_FLIP_THIS
#
# Commands:
#   hubot tableflip | tf - Returns a random flipped table!
#   hubot tableflip | tf this - Returns a flipped table of configurable word ( or arrgh! )!
#   hubot tableflip | tf this <text> - Returns a flipped table of <text>!
#   hubot tableflip | tf <text> - Returns a specific flipped table based on <text> else flips <text>!
#   hubot table_list - Returns a list of flippable tables!
#
# Author:
#   Jarrett Drouillard ( @kuatsure )

TABLEFLIP =
  base_url: 'http://table-flip.herokuapp.com'

FLIPS = [
  name: 'flipping'
  description: 'the classic'
,
  name: 'patience'
  description: 'no flip'
,
  name: 'pudgy'
  description: 'fat flip'
,
  name: 'battle'
  description: 'fight to flip'
,
  name: 'me'
  description: 'the table\'s revenge'
,
  name: 'aggravated'
  description: 'FFFUUUUUU'
,
  name: 'putback'
  description: 'peace at last'
,
  name: 'dude'
  description: 'no tables nearby'
,
  name: 'emotional'
  description: 'I know that feel, bro'
,
  name: 'freakout'
  description: 'screw this game!'
,
  name: 'hercules'
  description: 'RAWR!'
,
  name: 'jedi'
  description: 'flip or flip not, there is no try'
,
  name: 'bear'
  description: 'but this table flipped just right'
,
  name: 'magical'
  description: 'not just an illusion'
,
  name: 'robot'
  description: 'all the good table flipping jobs...'
,
  name: 'russia'
  description: 'in Soviet Russia table flip you'
,
  name: 'happy'
  description: 'all smiles'
]

table_flip_names = []
table_flip_names.push flip.name for flip in FLIPS

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
    table_flips = []
    table_flips.push "#{flip.name} - #{flip.description}" for flip in FLIPS

    msg.send "You can flip these tables! :v:\n\n#{table_flips.join '\n'}\n\nHappy Flipping! :sunglasses:"

  robot.respond /t(ableflip|f)( .*)?/i, ( msg ) ->
    { rest } = require 'lodash'

    if msg.match[2]?
      match = msg.match[2].substring 1
      parts = match.split ' '

      if parts[0] in table_flip_names and parts.length is 1
        match = parts[0]

      else if parts[0] is 'this'
        if parts.length > 1
          match = _flipping rest parts

        else
          tableFlipThis = process.env.HUBOT_TABLE_FLIP_THIS or 'arrgh!'
          match = _flipping [ tableFlipThis ]

      else
        match = _flipping parts

    else
      match = msg.random table_flip_names

    _flipIt msg, match, ( flippage ) ->
      msg.send flippage
