class_name StateMachine
extends Node

@export var bug: Bug

var current_state: BugState

var is_awake = false
func awake(new_bug: Bug, init_state: BugState):
  bug = new_bug
  is_awake = true
  change_state(init_state)

func can_run() -> bool:
  return current_state != null and is_awake

func _process(delta: float) -> void:
  if !can_run(): return
  current_state.on_process(delta)
  
func _physics_process(delta: float) -> void:
  if !can_run(): return
  current_state.on_physics(delta)
  
func _input(event: InputEvent) -> void:
  if !can_run(): return
  current_state.on_input(event)
  
func change_state(new_state: BugState) -> void:
  print("changing states")
  if current_state != null:
    current_state.on_exit()
    current_state.on_change_state.disconnect(change_state)
  current_state = new_state
  current_state.on_change_state.connect(change_state)
  current_state._bug = bug
  current_state.on_enter()
