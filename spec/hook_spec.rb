RSpec.describe DeepState::Hook do
  describe "run" do
    let(:hook) { DeepState::Hook.new({}, &block) }
    let(:context) { {} }
    let(:event) { :wake }
    let(:from) { :sleeping }
    let(:to) { :hungry }
    let(:machine) { LifeOfACat.new :sleeping, test_key: :success }

    subject { hook.run machine, event, from, to }

    context "block" do
      context "with no parameters" do
        let(:block) { -> { context.test_key } }

        it "can access the context object", :focus do
          expect(subject).to eq(:success)
        end
      end

      context "with no parameters" do
        let(:block) { -> { :success } }

        it "executes the block", :focus do
          expect(subject).to eq(:success)
        end
      end

      context "with event parameter" do
        let(:block) { ->(event) { [event] } }

        it "executes the block", :focus do
          expect(subject).to eq([:wake])
        end
      end

      context "with event and from parameters" do
        let(:block) { ->(event, from) { [event, from] } }

        it "executes the block", :focus do
          expect(subject).to eq([:wake, :sleeping])
        end
      end

      context "with event, from, and to parameters" do
        let(:block) { ->(event, from, to) { [event, from, to] } }

        it "executes the block", :focus do
          expect(subject).to eq([:wake, :sleeping, :hungry])
        end
      end
    end
  end
end
