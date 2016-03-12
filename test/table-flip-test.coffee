chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'table-flip', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/table-flip')(@robot)

  it 'registers a respond listener to /t(ableflip|f)( .*)?/i', ->
    expect(@robot.respond).to.have.been.calledWith(/t(ableflip|f)( .*)?/i)

  it 'registers a respond listener to /table_list/i', ->
    expect(@robot.respond).to.have.been.calledWith(/table_list/i)
