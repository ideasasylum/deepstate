module DeepState
  class Event
    attr_reader :name, :from, :to, :conditions

    def initialize name, from_state, to_state, conditions={}, &block
      @name = name
      @from = from_state
      @to = to_state
      @conditions = conditions
      @block = block
    end

    # check the conditions to see if the hook should run
    def run? context
      if_condition = conditions['if'] || conditions[:if]
      unless_condition = conditions['unless'] || conditions[:unless]

      return true unless (if_condition || unless_condition)

      check_condition(if_condition, context) &&
      check_condition(unless_condition, context)
    end

    def delay
      conditions['in'] || conditions[:in]
    end

    def delayed?
      !delay.nil?
    end

    def run
      # run the block in the context of the state
    end

    private

    def check_condition condition, context
      return true if condition.nil?

      # run the block in the context of the machine
      # but handle different variation of argument blocks
      result = case condition.arity
      when 0 then context.instance_exec(&condition)
      when 1 then context.instance_exec(name, &condition)
      when 2 then context.instance_exec(name, from, &condition)
      when 3 then context.instance_exec(name, from, to, &condition)
      end

      # Ensure we only return true/false
      result ? true : false
    end
  end
end
