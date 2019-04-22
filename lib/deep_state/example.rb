require "deep_state"

# IncidentStateMachine.build incident: incident
class DeepState::Example
  extend DeepState

  on_enter do
    incident.state = state
    incident.save!
  end

  # The incident has been created
  initial :open do
    on_enter do
      # notify slack
    end

    initial :starting do
      event start: :waking, if: -> { incident.wake_immediately? }
      event start: :waiting, unless: -> { incident.wake_immediately? }
    end

    state :waiting do
      event wake: :waking, after: -> { incident.wait_time }
    end

    state :waking do
      initial :phoning do
        on_enter do
          # Actually attempt calling them
          results = MakeItRing.call user: context.user
          context.call = results.call
        end

        # after 1.minute do
        #   fail! if state.phoning?
        # end

        event retry: :phoning do
          # on_event do
          #   # Text the user if this is the first failed call attempt
          #   return unless history[:retry].none?

          #   SendTextMessage.call call: call
          # end
        end

        event fail: :failed
        event answer: :answered
        event fail: :cancelled
      end

      state :waiting do
        event phone: :phoning, after: -> { call.delay }
      end

      state :failed do
        on_enter do
          if context.call.can_be_retried?
            retry!
          else
            # If possible, call the next contact
            next_user = roster.next(after: call.user)
            if next_user
              context.user = next_user
              retry!
            else
              cancel!
            end
          end
        end

        event cancel: :cancelled
        event retry: :phoning
      end

      state :cancelled

      state :answered do
        on_enter do
          assign!
        end
      end
    end

    event assign: :assigned

    event alert: :open do # => nil means don't change the state
      # Update Slack with a message
      # Send an SMS to the current too
    end
  end

  state :assigned do
    on_enter do
      incident.assign context.user
    end

    # Receive an update
    event alert: :assigned do
      # Update Slack with a message
    end

    event close: :closed
  end

  terminal :closed
end
