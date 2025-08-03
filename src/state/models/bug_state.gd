class_name BugState
extends RefCounted

var _bug: Bug

## decoupling -
## the state machine connects to this when swapping to the state, and disconnects when swapping away from it.
## states should emit this with an accompanying new state when they need to change states
signal on_change_state(state: BugState)

#region lifecycle
## Setup for our state before we transition to it
func on_enter() -> void:
  pass
  
## Teardown/ cleanup for our state before we transition to our new state
func on_exit() -> void:
  pass
#endregion

#region passthru
## Pass-through for the _process func. Anything that happens on the frame of our object should happen here
func on_process(_delta: float) -> void:
  pass

## Pass-through for the _physics_process func. Anything that happens on the physics frame of our object should happen here
func on_physics(_delta: float) -> void:
  pass

## Pass-through for the _input func. Any input for our state should be handled here
func on_input(_input: InputEvent) -> void:
  pass
#endregion
