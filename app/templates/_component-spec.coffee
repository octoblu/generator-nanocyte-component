ReturnValue = require 'nanocyte-component-return-value'
<%= _.classify(componentName) %> = require '../src/<%= _.slugify(componentName) %>'

describe '<%= _.classify(componentName) %>', ->
  beforeEach ->
    @sut = new <%= _.classify(componentName) %>

  it 'should exist', ->
    expect(@sut).to.be.an.instanceOf ReturnValue

  describe '->onEnvelope', ->
    describe 'when called with an envelope', ->
      it 'should return the message', ->
        expect(@sut.onEnvelope({message: 'anything'})).to.deep.equal 'anything'
