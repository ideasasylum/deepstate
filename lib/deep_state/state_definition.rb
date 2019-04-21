require "deep_state/validation_visitor"

module DeepState
  class StateDefinition
    attr_reader :name, :type, :hooks, :events, :states,
                :initial_state, :terminal_state, :parent_state

    def initialize name, parent_state=nil, type: :state
      @name = name
      @type = type
      @hooks = { on_enter: [] }
      @parent_state = parent_state
      @events = {}
      @states = []
      @initial_state = nil
      @terminal_state = nil
    end

    # Create an initial sub-state
    def initial name, args={}, &block
      raise DuplicateInitialState if @initial_state

      # Create a substate
      s = StateDefinition.new name, self, type: :initial
      # PRocess the definition as a block
      s.instance_eval &block if block_given?
      # Store this as a state
      @states << s
      # Assign this substate as the initial state
      @initial_state = s
    end

    # Define an on_enter event handler
    def on_enter conditions={}, &block
      hooks[:on_enter] << DeepState::Hook.new(self, conditions, &block)
    end

    # Create a new substate
    def state name, &block
      s=StateDefinition.new name, self
      s.instance_eval &block if block_given?
      # Add the state to the list of states
      @states << s
      s
    end

    # Create a transition between states
    def event transition, conditions={}, &block
      name = transition.keys.first
      destination = transition.values.first
      e = DeepState::Event.new name, self, destination, conditions
      e.instance_eval &block if block_given?
      @events[name.to_sym] = e
      e
    end

    # Create a terminal state
    def terminal name
      # Create a substate
      s = StateDefinition.new name, type: :terminal
      # Process the definition as a block
      s.instance_eval &block if block_given?
      # Store the terimnal state in the list of states
      @states << s
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

    def compound_state?
      states.any?
    end

    def atomic_state?
      states.none?
    end

    def validate
      validator = check_validity DeepState::ValidationVisitor.new
      validator.valid?
    end

    # Pass in the validator to build up a picture of the state machine
    def check_validity validator
      validator.visit self
      states.each { |state| state.check_validity(validator) }
      validator
    end
  end
end
