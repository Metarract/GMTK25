extends Node2D

var load_time:float = 0.0

@onready var main_controller = get_tree().current_scene

func _process(delta: float) -> void:
  load_time += delta

func _unhandled_input(event: InputEvent) -> void:
  if load_time < 0.75 or (event is InputEventMouse and event is not InputEventMouseButton): return
  
  #get_tree().change_scene_to_packed(load("res://src/main.tscn"))
  main_controller.change_state(1) # 1 = game_states.PLAYING .. probably better to send a signal, but meh. GAME JAM!
