ReturnValue = require 'nanocyte-component-return-value'

class <%= _.classify(componentName) %> extends ReturnValue
  onEnvelope: (envelope) =>
    return envelope.message

module.exports = <%= _.classify(componentName) %>
