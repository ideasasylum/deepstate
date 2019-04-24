module DeepState
  class MachineVisitor
    attr_reader :states, :events

    def initialize
      @states = {}
      @events = {}
    end

    # Collect the state and event data
    def visit state
      @states[state.name] = state unless state.root?
      @events.merge! state.events
    end
  end
end
