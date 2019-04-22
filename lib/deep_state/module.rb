require "ostruct"

# Top-level module interface and DSL
module DeepState
  # The initial state. Basically just a state with a label
  def initial name, args = {}, &block
    root_state_definition.initial name, args, &block
  end

  # Define a state
  def state name, args = {}, &block
    root_state_definition.state name, &block
  end

  # Hook call when every state is entered. Like a global handler
  def on_enter &block
    root_state_definition.on_enter &block
  end

  # The terminal state. Basically just a state with a label
  def terminal name, &block
    root_state_definition.terminal name, &block
  end

  def root_state_definition
    @@root_state_definition ||= StateDefinition.new :root, nil
  end

  # Create an instance of this state machine with the context
  def build current_state, context
    StateChart.new root_state_definition, context
  end
end
