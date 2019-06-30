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
      check_state_names
      check_event_names
      check_initial_state_exists
      check_initial_states

      true
    end

    def check_state_names
      names = duplicate_state_names
      return if names.empty?
      raise DeepState::DuplicateStateError.new(names)
    end

    def check_event_names
      events = duplicate_events
      return if events.empty?

      raise DeepState::DuplicateEventError.new(events)
    end

    def check_initial_state_exists
      states = compound_state_without_initial_state
      return if states.empty?

      raise DeepState::MissingInitialStateError.new(states)
    end

    def check_initial_states
      states = states_with_than_one_initial_state
      return if states.empty?

      raise DeepState::DuplicateInitialStateError.new(states)
    end


    def compound_state_without_initial_state
      @states.select { |state|
        state.compound_state? && state.initial_state.nil?
      }
    end

    def duplicate_state_names
      states_by_name.select { |name, states|
        states.length > 1
      }.values.flatten
    end

    def duplicate_events
      events_by_name.select { |name, events|
        events.length > 1
      }.values.flatten
    end

    def states_with_than_one_initial_state
      initial_states_by_parent_state.select { |parent, initial_states|
        initial_states.length > 1
      }.values.flatten
    end

    def initial_states_by_parent_state
      initial_states.group_by {|s| s.parent_state }
    end

    def events_by_name
      events.group_by(&:name)
    end

    def states_by_name
      states.group_by(&:name)
    end
  end
end
