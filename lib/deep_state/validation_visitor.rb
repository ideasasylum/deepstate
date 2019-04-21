module DeepState
  class ValidationVisitor
    attr_reader :states, :events, :terminal_states, :initial_states

    def initialize
      @states = []
      @events = []
      @terminal_states = []
      @initial_states = []
    end

    # Collect the state and event data
    def visit state
      @states << state
      @initial_states << state if state.initial?
      @terminal_states << state if state.terminal?
      @events += state.events.values
    end

    def valid?
      begin
        validate
        return true
      rescue DeepState::Error
        return false
      end
    end

    def validate
      validity = true

      initial_states_by_parent_state = initial_states.group_by {|s| s.parent_state }
      raise DeepState::Error if initial_states_by_parent_state.any? {|parent, initial_states| initial_states.length > 1}

      events_by_name = events.group_by &:name
      raise DeepState::Error if events_by_name.any? { |e| e.length > 1 }

      states_by_name = states.group_by &:name
      raise DeepState::Error if states_by_name.any? { |s| s.length > 1 }

      validity
    end
  end
end
