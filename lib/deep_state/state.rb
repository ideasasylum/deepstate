# Runtime state. Is this needed? I don't think so
class State
  attr_reader :type, :states

  def initialize type, context
    @context = OpenStruct.new context
    @type = type
    @states = []
  end

  def initial?
  end

  def terminal?
  end

  def nested?
  end
end
