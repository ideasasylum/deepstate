module DeepState
  class DotVisitor
    attr_reader :states, :events, :terminal_states, :initial_states

    def initialize
      @states = []
      @events = []
      @terminal_states = []
      @initial_states = []
      @dot = header
      @previous_states = []
    end

    # Collect the state and event data
    def visit state
      # binding.pry if state.name == :assigned
      @states << state
      @initial_states << state if state.initial?
      @terminal_states << state if state.terminal?
      @events.unshift(*state.events.values) if state.events.any?


      if state.parent_state
        # Close the subgraph
        while @previous_states.any? && @previous_states.last != state.parent_state
          @previous_states.pop
          puts "}"
          @dot << indent(end_subgraph)
        end

        puts state.name

        # Start a subgraph
        if state.compound_state?
          @dot << indent(subgraph(state))
          puts "{"
          # Remember the previous state
          @previous_states << state
        else
          @dot << indent(state_line(state))
        end
      end

      # Add the events
      state.events.values.each { |e| @dot << indent(event_line(e)) }
    end

    def indent s
      (' '*(@previous_states.length+1)*2)+s
    end

    def to_s
      # buffer = header
      # states.each { |s| buffer << state_line(s) }
      # events.each { |e| buffer << event_line(e) }
      @dot << footer
      @dot
    end

    def state_line s
      # binding.pry if s.name == :assigned
      "#{s.name} [shape=box color=#{s.initial? ? 'green' : 'black' }];\n"
    end

    def event_line e
      "#{e.from} -> #{e.to} [label=#{e.name}]\n"
    end

    def subgraph s
      <<-STR
    subgraph cluster_#{s.name} {
    #{s.name}
    label=#{s.name}
    color=#{s.initial? ? 'green' : 'black' }
    STR
    end

    def end_subgraph
      "}\n"
    end

    def header
      "digraph test {\n"
    end

    def footer
      "}\n"
    end
  end
end
