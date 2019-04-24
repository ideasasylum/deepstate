RSpec.describe DeepState::StateMachine do
  class SleepingExample
    include DeepState

    initial :sleeping do
      event wake: :awake
      event die: :dead

      initial :dreaming do
        event rest: :rem
      end

      state :rem do
        event dream: :dreaming
      end
    end

    state :awake do
      event die: :dead
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
      it 'fetches the transitions in inside-out order' do
        expect(machine.transitions.collect(&:name)).to eq([:rest, :wake, :die])
      end
    end
  end

  describe 'is?' do
    context 'atomic state' do
      let(:current_state) { :dead }

      it 'checks the current state' do
        expect(machine.is?(:dead)).to be(true)
        expect(machine.is?(:alive)).to be(false)
      end
    end

    context 'for a compound state' do
      let(:current_state) { :dreaming }

      it 'is true for all current states' do
        expect(machine.is?(:dreaming)).to be(true)
        expect(machine.is?(:sleeping)).to be(true)
        expect(machine.is?(:awake)).to be(false)
      end
    end
  end

  describe 'can?' do
    context 'atomic state' do
      let(:current_state) { :dead }

      it 'checks the current state' do
        expect(machine.can?(:restart)).to be(true)
        expect(machine.can?(:wake)).to be(false)
      end
    end

    context 'for a compound state' do
      let(:current_state) { :dreaming }

      it 'is true for all current states' do
        expect(machine.can?(:rest)).to be(true)
        expect(machine.can?(:wake)).to be(true)
        expect(machine.can?(:dream)).to be(false)
      end
    end
  end

end
