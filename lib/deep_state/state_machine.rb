require 'deep_state/machine_visitor'

module DeepState
  module StateMachine
    attr_accessor :current_state

    # Create an instance of this state machine with a given context
    def initialize root_definition, context
      @root = root_definition
      @context = context

      @details = DeepState::MachineVisitor.new
      root_definition.visit @details

      self
    end

    def current_state=state_name
      @current_state = @details.states[state_name]
    end

    def current_states
      current_state.parents.collect &:name
    end

    def transition event_name
      event = current_state.events[event_name]

      current_state = event.to
    end
  end
end
