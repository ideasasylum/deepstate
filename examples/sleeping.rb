class SleepingExample
  include DeepState

  initial :sleeping do
    event :wake, :awake
    event :die_peacefully, :dead

    initial :dreaming do
      event :rest, :rem
    end

    state :rem do
      event :dream, :dreaming
    end
  end

  state :awake do
    event :drop_dead, :dead
    initial :sleepy do
      event :drink_coffee, :ready_for_the_day
    end

    state :ready_for_the_day
  end

  state :dead do
    event :restart, :awake
  end
end
