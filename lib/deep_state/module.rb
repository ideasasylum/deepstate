require "ostruct"

# Top-level module interface and DSL
module DeepState

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # The initial state. Basically just a state with a label
    def initial name, args = {}, &block
      root_state_definition.initial name, args, &block
    end

    # Define a state
    def state name, args = {}, &block
      root_state_definition.state name, &block
    end

    # Hook call when every state is entered. Like a global handler
    def on_entry &block
      root_state_definition.on_entry &block
    end

    # Hook call when every state is entered. Like a global handler
    def on_exit &block
      root_state_definition.on_exit &block
    end

    # The terminal state. Basically just a state with a label
    def terminal name, &block
      root_state_definition.terminal name, &block
    end

    def root_state_definition
      @root_state_definition ||= StateDefinition.new :root, nil
    end

    def new *args, &block
      instance = allocate
      instance.singleton_class.include(DeepState::StateMachine)
      instance.send(:initialize, root_state_definition, *args, &block)
    end
  end

end
