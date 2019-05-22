module DeepState
  module Delayed
    module Sleep
      class Adapter
        def self.call machine, event
          existing_state = machine.current_state

          sleep event.delay

          raise DeepState::Error unless machine.can?(event.name)

          machine.execute_transition event
        end
      end
    end
  end
end
