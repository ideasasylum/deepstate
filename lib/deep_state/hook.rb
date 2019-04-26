module DeepState
  class Hook
    attr_reader :state, :conditions

    def initialize state, conditions, &block
      @state = state
      @conditions = conditions
      @block = block
    end

    def run?
      # check the conditions to see if the hook should run
    end

    def run
      # run the block in the context of the state
      @block.call
    end
  end
end
