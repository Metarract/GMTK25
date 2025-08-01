class_name SpawningStrategy
extends RefCounted
## class for use by spawn controller
## extend this for different spawning types
## should (usually) contain a couple lists of spawns to run through

signal try_spawn_bug(bug: Bug, gpos: Vector2)

var _global_spawn_positions: PackedVector2Array

var can_spawn := false

func _init(global_spawn_positions: PackedVector2Array) -> void:
  _global_spawn_positions = global_spawn_positions

## for our controller to use
func on_enter() -> void:
  pass
func on_process(_delta: float) -> void:
  pass
func on_exit() -> void:
  pass
