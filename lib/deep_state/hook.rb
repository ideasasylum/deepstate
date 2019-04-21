module DeepState
  class Hook
    def initialize state, conditions, &block
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
