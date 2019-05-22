require "life_of_a_cat"

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
      expect(root.states[:waiting]).to eq(initial_state)
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
        initial_state.event :resume, :active
      end

      let!(:nested_state) do
        initial_state.state :active
      end

      it "adds the events" do
        expect(initial_state.events[:resume]).to eq(event)
      end

      it "adds the nested state" do
        expect(initial_state.states[:active]).to eq(nested_state)
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
      expect(root.states[state.name]).to eq(state)
    end

    it "sets the name of the state" do
      expect(state.name).to eq(:active)
    end

    it "sets the type to :state" do
      expect(state.type).to eq(:state)
    end
  end

  describe "#on_entry" do
    let(:root) { DeepState::StateDefinition.new "root", nil }

    let!(:state) do
      root.state :active do
        on_entry
      end
    end

    it "adds the hook to the hooks list" do
      expect(state.on_entry_hooks.length).to eq(1)
    end

    it "is a Hook" do
      expect(state.on_entry_hooks.first).to be_a(DeepState::Hook)
    end
  end

  describe "#on_exit" do
    let(:root) { DeepState::StateDefinition.new "root", nil }

    let!(:state) do
      root.state :active do
        on_exit
      end
    end

    it "adds the hook to the hooks list" do
      expect(state.on_exit_hooks.length).to eq(1)
    end

    it "is a Hook" do
      expect(state.on_exit_hooks.first).to be_a(DeepState::Hook)
    end
  end

  describe "entry_hooks_list" do
    let(:context) { {} }
    let(:current_state) { :sleeping }
    let(:machine) { LifeOfACat.new current_state, context }

    it "returns the hooks as an array from outside-in" do
      details = DeepState::MachineVisitor.new
      LifeOfACat.root_state_definition.visit details

      expect(details.states[current_state]
             .entry_hooks_list.collect { |hook|
               hook.run(machine)
             }.to_a)
        .to eq(["sit", "lick paws", "curl up"])
    end
  end

  describe "entry_hooks_list" do
    let(:context) { {} }
    let(:current_state) { :sleeping }
    let(:machine) { LifeOfACat.new current_state, context }

    it "returns the hooks as an array inside-out" do
      details = DeepState::MachineVisitor.new
      LifeOfACat.root_state_definition.visit details

      expect(details.states[current_state]
             .exit_hooks_list.collect { |hook|
               hook.run(machine)
             }.to_a)
        .to eq(["stretch", "find hoomin", "tail up!"])
    end
  end

  describe "parents" do
    let!(:root) { DeepState::StateDefinition.new(:root) }
    let!(:one) { root.initial :one }
    let!(:one_one) { one.initial :one_one }
    let!(:one_two) { one.state :one_two }
    let!(:two) { root.state :two }
    let!(:two_one) { two.initial :two_one }
    let!(:two_two) { two.state :two_two }
    let!(:two_two_one) { two_two.initial :two_two_one }

    subject { state.parents }
    let(:state) { two_two_one }

    it "yield the parents" do
      expect { |b| subject.each(&b) }.to yield_successive_args(two_two, two)
    end

    context "root states" do
      let(:state) { one }

      it "does not include hidden root state" do
        expect { |b| subject.each(&b) }.to yield_successive_args
      end
    end

    describe "children" do
      let!(:root) { DeepState::StateDefinition.new(:root) }
      let!(:one) { root.initial :one }
      let!(:one_one) { one.initial :one_one }
      let!(:one_two) { one.state :one_two }
      let!(:two) { root.state :two }
      let!(:two_one) { two.initial :two_one }
      let!(:two_two) { two.state :two_two }
      let!(:two_two_one) { two_two.initial :two_two_one }

      subject { state.children }
      let(:state) { root }

      it "yield the initial child states" do
        expect { |b| subject.each(&b) }.to yield_successive_args(one, one_one)
      end

      context "substate state" do
        let(:state) { one }

        it "does not include hidden root state" do
          expect { |b| subject.each(&b) }.to yield_successive_args(one_one)
        end
      end

      context "atomic state" do
        let(:state) { one_one }

        it "does not include hidden root state" do
          expect { |b| subject.each(&b) }.to yield_successive_args
        end
      end
    end
  end

  describe "#visit" do
    context "with nested states" do
      let(:root) { DeepState::StateDefinition.new "root", nil }
      let!(:initial_state) do
        root.initial :waiting do
          event :resume, :active
        end
      end

      let!(:event) do
        root.event :stop, :finished
      end

      let(:visitor) { DeepState::ValidationVisitor.new }
      subject { root.visit visitor }

      it "visits the root then nested state" do
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
