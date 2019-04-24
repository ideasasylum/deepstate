RSpec.describe DeepState::StateMachine do
  class SleepingExample
    include DeepState

    initial :sleeping do
      event wake: :awake

      initial :dreaming do
        event rest: :rem
      end

      state :rem do
        event dream: :dreaming
      end
    end

    state :awake do
      initial :sleepy do
        event drink_coffee: :ready_for_the_day
      end

      state :ready_for_the_day
    end

    state :dead do
      event restart: :awake
    end
  end

  let(:context) { {} }
  let(:current_state) { :dreaming }
  let(:machine) { SleepingExample.new current_state, context }

  describe 'initialize' do
    it 'sets the current state' do
      expect(machine.current_state).to eq(current_state)
    end
  end

  describe 'transitions' do
    context 'atomic state' do
      let(:current_state) { :dead }

      it 'fetches the transitions' do
        expect(machine.transitions.collect(&:name)).to eq([:restart])
      end
    end

    context 'for a compound state' do
      let(:current_state) { :dreaming }
      it 'fetchs the transitions in inside-out order' do
        expect(machine.transitions.collect(&:name)).to eq([:rest, :wake])
      end
    end
  end
end
