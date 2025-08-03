extends Node2D

# main scene state controller
# also used to pass data and signals for audio, time, player, etc.

enum game_states {TITLE, PLAYING}
signal game_state_changed
signal game_scene_changed

# setting these to -1 throws a warning, but has to be done.. see the comment on the first line of change_state().
var current_state:game_states = -1
var previous_state:game_states = -1
var default_state:game_states = game_states.TITLE

var current_scene_path:String
var previous_scene_path:String

@onready var audio_controller:Node = $Audio # Controls BGM across scenes. TODO :: Move UI sfx frome Notebook to this controller
@onready var player:Node = $Player  # Holds bug inventory and currency
@onready var scene:Node2D = $Scene  # Parents the current active scene and related nodes.

func _ready() -> void: change_state(game_states.TITLE) #default_state)
func pause_game() -> void: get_tree().paused = true
func unpause_game() -> void: get_tree().paused = false
func exit_game() -> void: change_state(game_states.TITLE)

func change_state(s:game_states) -> void:
  if current_state == s: return # this line is why we have to start the enums at -1. if we try this or "if not s: return", then game_state 0 (the title menu) gets returned and doesn't process

  previous_state = current_state
  current_state = s

  emit_signal("game_state_changed")

  match current_state:
    game_states.TITLE:
      change_scene("res://src/ui/title_menu.tscn")
      audio_controller.play_bgm(audio_controller.bgm_title)

    game_states.PLAYING:
      change_scene("res://src/play_area.tscn")
      audio_controller.play_bgm(audio_controller.bgm_play)

      var play_area: PlayArea = scene.find_child("PlayArea", false, false)
      play_area.connect("exit_game", exit_game)
      player.connect("currency_changed", play_area.on_player_currency_change)

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
