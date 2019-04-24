RSpec.describe DeepState::ValidationVisitor do
  let(:visitor) { DeepState::ValidationVisitor.new }

  describe "#visit" do
    context "a state" do
      let(:state) { DeepState::StateDefinition.new "root", nil }

      before(:each) do
        state.event wait: :waiting
        state.event stop: :stopped
      end

      it "stores the states and events" do
        visitor.visit state

        expect(visitor.states).to include(state)
        expect(visitor.events.length).to eq(2)
        expect(visitor.events).to all(be_a(DeepState::Event))
      end
    end
  end

  describe "#validate" do
    let(:state1) { DeepState::StateDefinition.new :state1, nil }
    let(:state2) { DeepState::StateDefinition.new :state2, nil }
    let(:state3) { DeepState::StateDefinition.new :state3, nil }
    let(:states) { [state1, state2, state3] }

    before(:each) do
      states.each { |s| visitor.visit s }
    end

    subject { visitor.validate }

    it "returns true" do
      expect(subject).to eq(true)
    end

    context "with duplicate states" do
      let(:states) { [state1, state1, state2] }

      it "raises DeepState::Error" do
        expect {subject}.to raise_error(DeepState::Error)
      end
    end

    context "with duplicate states" do
      let(:compound_state) do
        DeepState::StateDefinition.new(:first).tap { |s|
          s.state :nested_state
        }
      end

      let(:states) { [compound_state] }

      it "raises DeepState::Error" do
        expect {subject}.to raise_error(DeepState::Error)
      end
    end

    context "with duplicate events" do
      let(:first_state) do
        DeepState::StateDefinition.new(:first).tap { |s|
          s.event next: :second_state
        }
      end

      let(:second_state) do
        DeepState::StateDefinition.new(:second).tap { |s|
          s.event next: :first_state
        }
      end

      let(:states) { [first_state, second_state] }

      it "raises DeepState::Error" do
        expect {subject}.to raise_error(DeepState::Error)
      end
    end
  end

  # it "validates the example" do
  #   root_state = DeepState::Example.root_state_definition
  #   root_state.validate
  # end
end
