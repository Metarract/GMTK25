class_name IdleBug
extends BugState

const IDLE_TIME_MAX := 5.0
const IDLE_TIME_MIN := 2.5
const DE_IDLE_CHANCE := 0.2

var idle_time_current := 0.0

func on_enter() -> void:
  idle_time_current = 0.0

func on_process(delta: float)-> void:
  idle_time_current += delta

  if idle_time_current < IDLE_TIME_MIN: return
  if idle_time_current >= IDLE_TIME_MAX:
    on_change_state.emit(MovingBug.new())
  elif randf() >= DE_IDLE_CHANCE:
    on_change_state.emit(MovingBug.new())