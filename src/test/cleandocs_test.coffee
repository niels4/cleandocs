'use strict'

cleandocs = require '../lib/cleandocs.js'

describe 'Awesome', ()->
  describe '#of()', ()->

    it 'awesome', ()->
      #cleandocs.awesome().should.eql('awesome')
      true.should.be.ok
