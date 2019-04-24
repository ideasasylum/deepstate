module DeepState
  class XStateVisitor
    attr_reader :states, :json

    def initialize
      @states = []
      @json = {}
      @json[:id] = 'test'
      @json[:states] = {}
    end

    # Collect the state and event data
    def visit state
      @states << state

      # Create the path of the parent nodes
      path = []
      parent = state.parents.each do |parent|
        path.unshift parent.name.to_sym
        path.unshift :states
      end
      # Use the path to find the right json node
      parent_doc = if path.any?
        @json.dig(*path)
      else
        @json
      end

      # Add the state
      parent_doc[:states] ||= {}
      if !state.root?
        parent_doc[:states][state.name.to_sym] = state_def(state)
      end

      # Add the initial states (top-level or for a substate)
      if state.root?
        parent_doc[:initial] = state.initial_state.name
      elsif state.compound_state?
        parent_doc[:states][state.name.to_sym][:initial] = state.initial_state.name
      end
    end

    def state_def state
      state_json = {}

      # Initialize the substates
      if state.compound_state?
        state_json[:states] = {}
      end

      # Add the events for this state
      if state.events.any?
        on = {}
        state.events.values.each { |e| on[e.name] = e.to }
        state_json[:on] = on
      end

      state_json
    end

    def to_s
      "const machine = Machine(\n#{@json.to_json}\n);"
    end
  end
end
