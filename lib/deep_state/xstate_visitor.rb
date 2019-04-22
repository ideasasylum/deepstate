module DeepState
  class XStateVisitor
    attr_reader :states, :events, :terminal_states, :initial_states

    def initialize
      @states = []
      @events = []
      @terminal_states = []
      @initial_states = []
      @json = {}
      @json[:id] = 'test'
      @json[:states] = {}
    end

    # Collect the state and event data
    def visit state
      print state.name
      # binding.pry if state.name == :assigned
      @states << state

      @initial_states << state if state.initial?
      @terminal_states << state if state.terminal?
      @events.unshift(*state.events.values) if state.events.any?

      # if state.parent_state
      path = []
      parent = state.parent_state
      while parent && !parent.root?
        path.unshift parent.name.to_sym
        path.unshift :states
        parent = parent.parent_state
      end

      puts path.inspect
      # binding.pry if path == []
      # binding.pry if @json[:states].dig(*path).nil?

      parent_doc = if path.any?
        @json.dig(*path)
      else
        @json
      end

      binding.pry if parent_doc.nil?

      binding.pry if state.name == :open

      parent_doc[:states] ||= {}
      if !state.root?
        parent_doc[:states][state.name.to_sym] = state_def(state)
      end

      if state.root?
        parent_doc[:initial] = state.initial_state.name
      elsif state.compound_state?
        parent_doc[:states][state.name.to_sym][:initial] = state.initial_state.name
      end
    end

    def state_def state
      state_json = {}
      if state.compound_state?
        state_json[:states] = {}
      end
      if state.events.any?
        on = {}
        state.events.values.each { |e| on[e.name] = e.to }
        state_json[:on] = on
      end
      state_json
    end

    def to_s
      "const fetchMachine = Machine(\n#{@json.to_json}\n);"
    end
  end
end
