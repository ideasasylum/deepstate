module DeepState
  module StateMachine
    attr_reader :current_state

    # Create an instance of this state machine with a given context
    def initialize root_definition, current_state_name=nil, context={}
      @root = root_definition
      @context = context

      @details = DeepState::MachineVisitor.new
      @root.visit @details

      validate

      # Default to the initial state
      first_state = fetch_state(current_state_name)
      first_state ||= @root
      set_current_state first_state

      self
    end

    def validate
      @root.validate
    end

    def current_state=state_name
      set_current_state fetch_state(state_name)
    end

    def current_states
      Enumerator.new { |yielder|
        s = fetch_state(current_state)
        yielder << s
        s.parents.each { |s| yielder << s }
      }
    end

    def transition event_name
      event = transitions.find { |t| t.name == event_name }
      raise DeepState::Error unless event

      set_current_state fetch_state(event.to)
    end

    def transitions
      current_states.flat_map { |s| s.events.values }
    end

    def can? transition_name
      transitions.any? { |e| e.name == transition_name }
    end

    def is? state_name
      current_states.any? { |s| s.name == state_name }
    end

    private

    def fetch_state name
      @details.states[name]
    end

    def fetch_event name
      @details.events[name]
    end

    def set_current_state state
      # Calculate the actual initial state if it's a compound state
      state = state.children.collect.to_a.last || state
      @current_state = state.name
    end
  end
end
