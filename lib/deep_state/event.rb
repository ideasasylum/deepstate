module DeepState
  class Event
    attr_reader :name, :from, :to

    def initialize name, from_state, to_state, conditions, &block
      @name = name
      @from = from_state
      @to = to_state
      @conditions = conditions
      @block = block
    end

    def run?
      # check the conditions to see if the hook should run
    end

    def run
      # run the block in the context of the state
    end
  end
end
