module DeepState
  class Hook
    attr_reader :conditions

    def initialize conditions, &block
      @conditions = conditions
      @block = block
    end

    def run?
      # check the conditions to see if the hook should run
    end

    def run machine, event=nil, from=nil, to=nil
      b = @block
      # run the block in the context of the machine
      case b.arity
      when 0 then machine.instance_exec(&b)
      when 1 then machine.instance_exec(event, &b)
      when 2 then machine.instance_exec(event, from, &b)
      when 3 then machine.instance_exec(event, from, to, &b)
      end
    end
  end
end
