class LifeOfACat
  include DeepState

  initial :hungry do
    on_entry do
      'meow'
    end

    event eat: :satisfied
  end

  state :satisfied do
    on_entry do
      'lick paws'
    end

    on_exit do
      'find hoomin'
    end

    initial :curious do
      on_entry do
        'explore'
      end

      on_exit do
        'knock things over'
      end

      event tired: :sleeping
      event bored: :sleeping
    end

    state :sleeping do
      on_entry do
        'curl up'
      end

      on_exit do
        'stretch'
      end

      event wake: :hungry
    end
  end
end
