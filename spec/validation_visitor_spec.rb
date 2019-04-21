RSpec.describe DeepState::ValidationVisitor do
  let(:visitor) { DeepState::ValidationVisitor.new }

  describe '#visit' do
    let(:root_state) { }

    context 'a state' do
      let(:state) { DeepState::StateDefinition.new 'root', nil }

      before(:each) do
        state.event :wait => :waiting
        state.event :stop => :stopped
      end

      it 'stores the states and events' do
        visitor.visit state

        expect(visitor.states).to include(state)
        expect(visitor.events.length).to eq(2)
        expect(visitor.events).to all(be_a(DeepState::Event))
      end
    end
  end

  # it "validates the example" do
  #   root_state = DeepState::Example.root_state_definition
  #   root_state.validate
  # end
end
