module DeepState
  class StateDefinition
    attr_reader :name, :type, :events, :states,
      :initial_state, :terminal_state, :parent_state

    def initialize name, parent_state = nil, type: :state
      @name = name
      @type = type
      @hooks = {on_entry: [], on_exit: []}
      @parent_state = parent_state
      @events = {}
      @states = {}
      @initial_state = nil
      @terminal_state = nil
    end

    # Create an initial sub-state
    def initial name, args = {}, &block
      raise DuplicateInitialState, "#{@initial_state.name} exists when adding #{name}" if @initial_state

      # Create a substate
      s = StateDefinition.new name, self, type: :initial
      # Process the definition as a block
      s.instance_eval(&block) if block_given?
      # Store this as a state
      @states[s.name] = s
      # Assign this substate as the initial state
      @initial_state = s
      s
    end

    # Define an on_entry event handler
    def on_entry conditions = {}, &block
      @hooks[:on_entry] << DeepState::Hook.new(conditions, &block)
    end

    # Define an on_entry event handler
    def on_exit conditions = {}, &block
      @hooks[:on_exit] << DeepState::Hook.new(conditions, &block)
    end

    def on_entry_hooks
      @hooks[:on_entry]
    end

    def on_exit_hooks
      @hooks[:on_exit]
    end

    # Create a new substate
    def state name, &block
      s = StateDefinition.new name, self
      s.instance_eval(&block) if block_given?
      # Add the state to the list of states
      @states[s.name] = s
      s
    end

    # Create a transition between states
    def event transition, conditions = {}, &block
      name = transition.keys.first
      destination = transition.values.first
      e = DeepState::Event.new name, self.name, destination, conditions
      e.instance_eval(&block) if block_given?
      @events[name.to_sym] = e
      e
    end

    # Create a terminal state
    def terminal name
      # Create a substate
      s = StateDefinition.new name, self, type: :terminal
      # Process the definition as a block
      s.instance_eval(&block) if block_given?
      # Store the terminal state in the list of states
      @states[s.name] = s
      # Assign this substate as the terminal state
      @terminal_state = s
      s
    end

    # Is this the initial state
    def initial?
      type == :initial
    end

    # Is this the terminal state
    def terminal?
      type == :terminal
    end

    def root?
      parent_state.nil?
    end

    def compound_state?
      states.any?
    end

    def atomic_state?
      states.none?
    end

    # Return an enumerator of each parent state
    def parents include_root: false
      Enumerator.new do |yielder|
        # Walk up the parent states, excluding the very root state
        p = parent_state
        while p
          yielder << p if include_root || !p.root?
          p = p.parent_state
        end
      end
    end

    def children
      Enumerator.new do |yielder|
        # Walk down the initial states
        s = initial_state
        while s
          yielder << s
          s = s.initial_state
        end
      end
    end

    def validate
      # Pass in the validator to build up a picture of the state machine
      validator = visit DeepState::ValidationVisitor.new
      validator.validate
    end

    def entry_hooks_list
      (on_entry_hooks + parents(include_root: true).collect { |s| s.on_entry_hooks })
        .flatten
        .reverse
    end

    def exit_hooks_list
      (on_exit_hooks + parents(include_root: true).collect { |s| s.on_exit_hooks })
        .flatten
    end

    # Iterate as a depth-first search through the states, and call visitor#visit
    # on the visitor instance for each state
    def visit visitor
      visitor.visit self
      states.each { |name, state| state.visit(visitor) }
      visitor
    end

    def to_dot
      visit DeepState::DotVisitor.new
    end

    def to_js
      visit DeepState::XStateVisitor.new
    end
  end
end
