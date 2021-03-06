RSpec.describe DeepState::ValidationVisitor do
  let(:visitor) { DeepState::ValidationVisitor.new }

  describe "#visit" do
    context "a state" do
      let(:state) { DeepState::StateDefinition.new "root", nil }

      before(:each) do
        state.event :wait, :waiting
        state.event :stop, :stopped
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

      it "raises DeepState::DuplicateStateError" do
        expect {subject}.to raise_error(DeepState::DuplicateStateError)
                            .with_message("Duplicate states [:state1, :state1]")
      end
    end

    context "with duplicate initial states" do
      let(:state1) { DeepState::StateDefinition.new :state1, nil, type: :initial }
      let(:state2) { DeepState::StateDefinition.new :state2, nil, type: :initial }
      let(:states) { [state1, state2, state3] }

      it "raises DeepState::DuplicateInitialStateError" do
        expect {subject}.to raise_error(DeepState::DuplicateInitialStateError)
                            .with_message("Duplicate initial states: [:state1, :state2]")
      end

    end

    context "with missing initial states" do
      let(:compound_state) do
        DeepState::StateDefinition.new(:first).tap do |s|
          s.state :nested_state
        end
      end

      let(:states) { [compound_state] }

      it "raises DeepState::MissingInitialStateError" do
        expect {subject}.to raise_error(DeepState::MissingInitialStateError)
      end
    end

    context "with duplicate events" do
      let(:first_state) do
        DeepState::StateDefinition.new(:first).tap do |s|
          s.event :next, :second_state
        end
      end

      let(:second_state) do
        DeepState::StateDefinition.new(:second).tap do |s|
          s.event :next, :first_state
        end
      end

      let(:states) { [first_state, second_state] }

      it "raises DeepState::DuplicateEventError" do
        expect {subject}.to raise_error(DeepState::DuplicateEventError)
                            .with_message("Duplicate events [:next, :next]")
      end
    end
  end
end
