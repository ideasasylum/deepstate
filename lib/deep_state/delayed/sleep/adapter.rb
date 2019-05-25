module DeepState
  module Delayed
    module Sleep
      class Adapter
        def self.call machine, event
          existing_state = machine.current_state
          last_modification = machine.updated_at

          sleep event.delay

          # Cancel this transition if the machine state was already changed
          raise DeepState::Error if machine.updated_at > last_modification
          # Cancel the transition if it's no longer valid
          raise DeepState::Error unless machine.can?(event.name)

          machine.execute_transition event
        end
      end
    end
  end
end
