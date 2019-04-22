RSpec.describe DeepState::StateDefinition do
  describe "#initial_state" do
    let(:root) { DeepState::StateDefinition.new "root", nil }

    let!(:initial_state) do
      root.initial :waiting
    end

    it "sets the initial state" do
      expect(root.initial_state).to eq(initial_state)
    end

    it "includes the initial state in the states" do
      expect(root.states).to include(initial_state)
    end

    it "sets the name of the initial state" do
      expect(initial_state.name).to eq(:waiting)
    end

    it "sets the type to :initial" do
      expect(initial_state.type).to eq(:initial)
    end

    it "is an atomic state" do
      expect(initial_state).to be_atomic_state
    end

    context "with a block definition" do
      let!(:event) do
        initial_state.event resume: :active
      end

      let!(:nested_state) do
        initial_state.state :active
      end

      it "adds the events" do
        expect(initial_state.events[:resume]).to eq(event)
      end

      it "adds the nested state" do
        expect(initial_state.states).to include(nested_state)
      end

      it "an atomic state" do
        expect(nested_state).to be_atomic_state
      end

      it "changes the parent to a compound state" do
        expect(initial_state).to be_compound_state
      end

      it "sets the parent state" do
        expect(nested_state.parent_state).to eq(initial_state)
      end
    end
  end

  describe "#state" do
    let(:root) { DeepState::StateDefinition.new "root", nil }

    let!(:state) do
      root.state :active
    end

    it "adds the state to the states list" do
      expect(root.states).to include(state)
    end

    it "sets the name of the state" do
      expect(state.name).to eq(:active)
    end

    it "sets the type to :state" do
      expect(state.type).to eq(:state)
    end
  end

  describe "#check_validity" do
    context "with nested states" do
      let(:root) { DeepState::StateDefinition.new "root", nil }
      let!(:initial_state) do
        root.initial :waiting do
          event resume: :active
        end
      end

      let!(:event) do
        root.event stop: :finished
      end

      let(:visitor) { DeepState::ValidationVisitor.new }
      subject { root.check_validity visitor }

      it "visits the root then nested state", :focus do
        expect(visitor).to receive(:visit).with(root).ordered
        expect(visitor).to receive(:visit).with(initial_state).ordered
        subject
      end

      it "stores the states and events" do
        subject

        expect(visitor.states).to include(initial_state, root)
        expect(visitor.initial_states).to contain_exactly(initial_state)
        expect(visitor.events.length).to eq(2)
        expect(visitor.events).to all(be_a(DeepState::Event))
      end
    end
  end
end
