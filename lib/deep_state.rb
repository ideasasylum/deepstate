require "deep_state/version"
require "deep_state/module"
require "deep_state/dot_visitor"
require "deep_state/xstate_visitor"
require "deep_state/validation_visitor"
require 'deep_state/machine_visitor'
require "deep_state/state_definition"
require "deep_state/hook"
require "deep_state/event"
require "deep_state/state_machine"


module DeepState
  class Error < StandardError; end
  class DuplicateInitialState < StandardError; end
  # Your code goes here...
end
