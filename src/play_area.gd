class_name PlayArea
extends Node2D

signal exit_game
signal bug_captured(bug_stats: BugStats)

var _bugs_to_capture: Array = []
@onready var mouse_cap_check := $%MouseCaptureCheck
var notebook_menu: Notebook = null
var player_data: Player
@onready var day_hand := $%DayHand
var time: TimeController
var audio_controller: AudioController = null
@onready var current_cash:RichTextLabel = $PanelContainer/CurrentCash

func _ready() -> void:
  $SpawnController.bug_captured.connect(on_bug_captured)
  notebook_menu = $%Notebook
  notebook_menu.connect("exit_game", on_exit_game)
  # notebook_menu.connect("journal_closed", on_player_currency_change)
  player_data = get_tree().current_scene.find_child("Player")
  audio_controller = get_tree().current_scene.find_child("Audio")
  bug_captured.connect(player_data.add_bug)

  time = $%TimeController
  time.day_ended.connect(on_day_end)
  time.reset_day_seconds()
  time._active = true

func _process(_delta: float) -> void:
  set_dayhand_rotation()

func _physics_process(_delta: float) -> void:
  mouse_cap_check.global_position = get_global_mouse_position()
  var hovered_bugs = get_hovered_bugs()
  var bugs_to_remove = []
  for bug in _bugs_to_capture:
    # check if we match at least one currently hovered bug
    if !hovered_bugs.any(func (h_bug: Bug): return h_bug == bug):
      # if we don't, remove ourselves
      bugs_to_remove.append(bug)
  for bug in bugs_to_remove:
    bug.is_being_captured = false
    _bugs_to_capture.erase(bug)
    
func on_player_currency_change() -> void:
  current_cash.text = "$%d" % [player_data.currency]

func on_capture_check(_event: InputEvent) -> void:
  if Input.is_action_just_pressed("capture"):
    _bugs_to_capture = get_hovered_bugs()
    if _bugs_to_capture.size() > 0:
      get_viewport().set_input_as_handled()
      for bug in _bugs_to_capture:
        bug.is_being_captured = true

  if Input.is_action_just_released("capture"):
    if _bugs_to_capture.size() == 0: return
    for bug in _bugs_to_capture:
      if bug == null or bug.is_queued_for_deletion(): continue
      bug.is_being_captured = false
    _bugs_to_capture.clear()

func get_hovered_bugs() -> Array:
  var bodies = mouse_cap_check.get_overlapping_bodies()
  return bodies.filter(is_bug)

func is_bug(coll: CollisionObject2D) -> bool: return coll is Bug

func on_bug_captured(bug_stats: BugStats, _active_bugs: int):
  audio_controller.play_capture_bug()
  bug_captured.emit(bug_stats)
  var i = _bugs_to_capture.find_custom(func (bug): return bug.bug_stats == bug_stats)
  if i == -1:
    printerr("couldn't find our captured bug")
    return
  _bugs_to_capture.remove_at(i)

func set_dayhand_rotation():
  day_hand.rotation_degrees = remap(time.seconds, 0.0, time.SECONDS_PER_DAY, 0, 90)

func on_day_end(_day: String):
  spawn_vendor()

func spawn_vendor():
  notebook_menu._on_delete_this_button_pressed().vendor_closed.connect(on_vendor_closed)
  var tween = create_tween()
  tween.set_ease(Tween.EASE_OUT)
  tween.set_trans(Tween.TRANS_SINE)
  tween.tween_property($%DarkenBg, "color", Color(0,0,0,0.7), 0.7)
  tween.tween_interval(0.2)
  tween.tween_callback(notebook_menu._on_exclaim_pressed)

func on_vendor_closed():
  var tween = create_tween()
  tween.set_ease(Tween.EASE_OUT)
  tween.set_trans(Tween.TRANS_SINE)
  tween.tween_property($%DarkenBg, "color", Color(0,0,0,0), 0.3)
  time.tick_day()

func on_exit_game():
  exit_game.emit()
