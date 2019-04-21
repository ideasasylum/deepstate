# Combined the state chart definition with the current state, context etc
class StateChart
  attr_reader :current_state

  def initialize state_definition, current_state, context
    # save the context
    # set the current state
  end

  def transition to
    # is there a matching event on the current state?
    # if not, check every parent state for a matching event
  end

  def can_transition? to
  end

  # The current state and all parents
  def current_states
  end
end
