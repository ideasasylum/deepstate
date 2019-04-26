RSpec.describe DeepState::MachineVisitor do
  let(:visitor) { DeepState::MachineVisitor.new }

  let(:root) do
    DeepState::StateDefinition.new(:root).tap do |s|
      s.initial :on_state do
        event off: :off_state
      end
      s.state :off_state do
        event on: :on_state
        event off_again: :off
      end
    end
  end

  subject { root.visit visitor }

  it "collects the states" do
    subject
    expect(visitor.states).to be_a(Hash)
    expect(visitor.states.length).to eq(2)
  end

  it "collects the events" do
    subject
    expect(visitor.events).to be_a(Hash)
    expect(visitor.events.length).to eq(3)
  end

  it "stores the states by name" do
    subject
    expect(visitor.states[:on_state]).to be_a(DeepState::StateDefinition)
  end

  it "stores the events by name" do
    subject
    expect(visitor.events[:on]).to be_a(DeepState::Event)
  end
end
