extends Node2D

# main scene controller which handles
# - spawning in new scenes (title menu, play area, etc)
# - bg music
# - pausing

enum game_states {TITLE, PLAYING}

signal game_state_changed
signal game_scene_changed

# setting these to -1 throws a warning, but has to be done.. see the comment on the first line of change_state().
var current_state:game_states = -1
var previous_state:game_states = -1
var default_state:game_states = game_states.TITLE

var current_scene_path:String
var previous_scene_path:String

var bgm_options = ["res://assets/Sounds/Music/Chiptune Vol2 Work Work Work Main.wav", "res://assets/Sounds/Music/Chiptune Vol2 Evil Grudge Main.wav"]

@onready var scene:Node2D = $Scene  # parents the current active scene
@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer # used for bgm
@onready var animation_player:AnimationPlayer = $AnimationPlayer

func _ready() -> void: change_state(default_state)
func pause_game() -> void: get_tree().paused = true
func unpause_game() -> void: get_tree().paused = false
func exit_game() -> void: change_state(game_states.TITLE)

func play_bgm(path:String) -> void:
  if not path: return
  
  animation_player.play("fade") # fade bgm vol out
  await  animation_player.animation_finished
  audio_stream_player.stream = load(path)
  audio_stream_player.play()
  animation_player.play_backwards("fade") # fade bgm vol in

func change_state(s:game_states) -> void:
  if current_state == s: return # this line is why we have to start the enums at -1. if we try this or "if not s: return", then game_state 0 (the title menu) gets returned and doesn't process 
   
  previous_state = current_state
  current_state = s
  
  emit_signal("game_state_changed")
  
  match current_state:
    game_states.TITLE:
      change_scene("res://src/ui/title_menu.tscn")
      play_bgm(bgm_options[0])
      
    game_states.PLAYING:
      change_scene("res://src/play_area.tscn")
      play_bgm(bgm_options[1])
      
      # load notebook menu object
      var notebook_menu = load("res://src/ui/notebook.tscn").instantiate()
      scene.add_child(notebook_menu)
      notebook_menu.connect("journal_opened", pause_game)
      notebook_menu.connect("journal_closed", unpause_game)
      notebook_menu.connect("exit_game", exit_game)
      
    _:
      print("ERR: Main game state unknown")
  
func change_scene(path:String) -> void:
  if not path: return
  
  previous_scene_path = current_scene_path
  current_scene_path = path
  
  # clear all current scene nodes
  for child in scene.get_children(): child.queue_free()

  # load the new scene
  var new_current_scene = load(current_scene_path).instantiate()
  scene.add_child(new_current_scene)
  
  emit_signal("game_scene_changed")
