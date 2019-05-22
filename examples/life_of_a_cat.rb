class LifeOfACat
  include DeepState

  on_exit do
    "tail up!"
  end

  on_entry do
    "sit"
  end

  initial :hungry do
    on_entry do
      "meow"
    end

    event :eat, :satisfied
  end

  state :satisfied do
    on_entry do
      "lick paws"
    end

    on_exit do
      "find hoomin"
    end

    initial :curious do
      on_entry do
        "explore"
      end

      on_exit do
        "knock things over"
      end

      event :tired, :sleeping
      event :bored, :sleeping
    end

    state :sleeping do
      on_entry do
        curl_up
      end

      on_exit do
        stretch
      end

      event :wake, :hungry, in: 1
    end
  end

  def stretch
    "stretch"
  end

  def curl_up
    "curl up"
  end
end
