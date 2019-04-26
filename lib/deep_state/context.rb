require 'ostruct'

module DeepState
  class Context < OpenStruct

    def initialize machine, args
      super(args)
      self.machine = machine
    end
  end
end
