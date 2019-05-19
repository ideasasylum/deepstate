require "sleeping"
require "life_of_a_cat"

RSpec.describe DeepState::Event do
  let(:machine) { nil }
  let(:context) { DeepState::Context.new machine, value: value }
  let(:value) { true }
  let(:if_condition) { ->(){ value } }
  let(:unless_condition) { ->(){ value } }
  let(:event) do
    DeepState::Event.new 'test', 'start', 'finished',
                         if: if_condition,
                         unless: unless_condition
 end

  describe 'run?' do
    let(:event) do
      DeepState::Event.new 'test', 'start', 'finished'
    end

    subject { event.run? context }

    context 'without conditions' do
      let(:if_condition) { nil }
      let(:unless_condition) { nil }

      it { is_expected.to eq(true) }
    end

    context 'with an if condition' do
      let(:event) do
        DeepState::Event.new 'test', 'start', 'finished', if: if_condition
      end

      let(:if_condition) { ->(){ true } }

      it { is_expected.to eq(true) }

      context 'unsuccessful' do
        let(:if_condition) { ->(){ false } }

        it { is_expected.to eq(false) }
      end
    end

    context 'with an unless condition' do
      let(:event) do
        DeepState::Event.new 'test', 'start', 'finished', unless: unless_condition
      end

      let(:unless_condition) { ->(){ true } }

      it { is_expected.to eq(true) }

      context 'unsuccessful' do
        let(:unless_condition) { ->(){ false } }

        it { is_expected.to eq(false) }
      end

    end

    context 'with both an if and unless condition' do
      let(:context) { DeepState::Context.new machine, if_value: if_value, unless_value: unless_value }
      let(:if_value) { true }
      let(:unless_value) { true }
      let(:event) do
        DeepState::Event.new 'test', 'start', 'finished', if: if_condition, unless: unless_condition
      end

      let(:if_condition) { ->(){ if_value } }
      let(:unless_condition) { ->(){ unless_value } }

      it { is_expected.to eq(true) }

      context 'unsuccessful if' do
        let(:if_value) { false }

        it { is_expected.to eq(false) }
      end

      context 'unsuccessful unless' do
        let(:unless_value) { false }

        it { is_expected.to eq(false) }
      end

      context 'successful if / unsuccessful unless' do
        let(:if_value) { true }
        let(:unless_value) { false }

        it { is_expected.to eq(false) }
      end

      context 'unsuccessful if / successful unless' do
        let(:if_value) { false }
        let(:unless_value) { true }

        it { is_expected.to eq(false) }
      end
    end

  end

end
