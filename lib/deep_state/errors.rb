module DeepState
  class Error < StandardError
  end

  class DuplicateInitialStateError < Error
    def initialize names
      @names = names
    end

    def message
      "Duplicate initial state #{@names}"
    end
  end

  class DuplicateStateError < Error
    def initialize names
      @names = names
    end

    def message
      "Duplicate states #{@names.collect(&:name)}"
    end
  end

  class DuplicateEventError < Error
    def initialize events
      @events = events
    end

    def message
      "Duplicate events #{@events.collect(&:name)}"
    end
  end

  class MissingInitialStateError < Error
    def initialize states
      @states = states
    end

    def message
      "Missing initial state for #{@states.collect(&:name)}"
    end
  end

  class DuplicateInitialStateError < Error
    def initialize states
      @states = states
    end

    def message
      "Duplicate initial states: #{@states.collect(&:name)}"
    end
  end

end
