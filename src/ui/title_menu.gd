extends Node2D

var load_time:float = 0.0

func _process(delta: float) -> void:
  load_time += delta

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventMouse or load_time < 0.75: return
  
  #var main:PackedScene = preload("res://src/main.tscn")
  get_tree().change_scene_to_packed(load("res://src/main.tscn"))
