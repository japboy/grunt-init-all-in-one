'use strict'

chai = require 'chai'
should = chai.should()

describe 'Sample test', ->

  before ->
    console.log 'Ready to be  unko...'

  after ->
    console.log 'Done to be unko!'

  describe 'Make sure unko is unko', ->
    it 'should be unko', ->
      'unko'.should.equal 'unko'

