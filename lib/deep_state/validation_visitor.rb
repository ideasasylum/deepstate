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
      @events.unshift(*state.events.values)
    end

    def valid?
      validate
      true
    rescue DeepState::Error
      false
    end

    def validate
      raise DeepState::Error if compound_state_without_initial_state?
      raise DeepState::Error if more_than_one_initial_state?
      raise DeepState::Error if duplicate_state_names?
      raise DeepState::Error if duplicate_event_names?

      true
    end

    def compound_state_without_initial_state?
      @states.any? { |state|
        state.compound_state? && state.initial_state.nil?
      }
    end

    def duplicate_state_names?
      states_by_name.any? { |name, states|
        states.length > 1
      }
    end

    def duplicate_event_names?
      events_by_name.any? { |name, events|
        events.length > 1
      }
    end

    def more_than_one_initial_state?
      initial_states_by_parent_state.any? {|parent, initial_states|
        initial_states.length > 1
      }
    end

    def initial_states_by_parent_state
      initial_states.group_by {|s| s.parent_state }
    end

    def events_by_name
      events.group_by &:name
    end

    def states_by_name
      states.group_by &:name
    end
  end
end
