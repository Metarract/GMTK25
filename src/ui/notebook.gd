class_name Notebook
extends Node2D

signal exit_game

var audio_pitch_variation:float = 0.2

var open:bool = false
var hovering:bool = false

var position_start_x:float = 535.0
var position_hover_x:float = 510.0
var position_open_x:float = 8.0
var lerp_weight = 7.5

@onready var player = get_tree().current_scene.player

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer

# Journal and tab nodes
@onready var journal = $Journal
@onready var settings_tab = $Journal/SettingsTab
@onready var bugs_tab = $Journal/BugsTab
@onready var exclaim_tab = $Journal/ExclaimTab

# Settings menu nodes
@onready var settings_menu = $SettingsMenu
@onready var settings_hslider_loud = $SettingsMenu/VBoxContainer/PanelContainer/VBoxContainer/HSliderLoud

# Bugs menu nodes
@onready var bugs_menu = $BugsMenu
@onready var bugs_menu_vbox = $BugsMenu/VBoxContainer
@onready var stats_graph_container = $BugsMenu/StatsGraph
@onready var stats_graph = $BugsMenu/StatsGraph/BugStatsDistributionGraph #.set_bug_stats(BugBuilder.new().ladybug()._bug_stats)

# Exclaim menu nodes
@onready var exclaim_menu = $ExclaimMenu
@onready var day_highlighter = $ExclaimMenu/DayHighlighter

func _ready() -> void:
  # set the LOUD slider value to the current audio level
  settings_hslider_loud.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

func _process(delta:float) -> void:
  if not open:
    # handle hoverover animation
    if hovering:
      if journal.position.x != position_hover_x:
        journal.position.x = lerp(journal.position.x, position_hover_x, lerp_weight * delta)
    else:
      if journal.position.x != position_start_x:
        journal.position.x =  lerp(journal.position.x, position_start_x, lerp_weight * delta)

func play_sfx(path:String) -> void:
  if not path: return

  var clip = load(path)
  if not clip: return

  # vary the pitch of SFX to prevent audio fatigue
  var pitch_variation = randf_range(-audio_pitch_variation, audio_pitch_variation)
  audio_stream_player.pitch_scale = 1.0 + pitch_variation

  # load and play

  audio_stream_player.stream = clip
  audio_stream_player.play()

func _on_h_slider_loud_value_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
  play_sfx("res://assets/Sounds/Library Scribbling B.wav")

func _on_close_stats_graph_pressed() -> void:
  # TODO: Get the stats graph to close proerply so we can get rid of this button
  stats_graph_container.visible = false

func _on_close_journal_pressed() -> void:
  # TODO: Get the journal to close proerply so we can get rid of this button
  close_journal()

func on_bug_tally_pressed(stats:BugStats) -> void:
  play_sfx("res://assets/Sounds/Library Foliant G Clipped.wav")
  stats_graph_container.visible = true
  stats_graph.set_bug_stats(stats)

#func _unhandled_input(event: InputEvent) -> void:
#  if event is InputEventMouseButton:
#    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
#      if open: close_journal()

func reset_journal() -> void:
  # hide all submenus and reset the layering on the tabs
  # TODO : update this with DT's fancy new sprites for a more accurate look
  settings_tab.z_index = -10
  bugs_tab.z_index = -10
  exclaim_tab.z_index = -10

  settings_menu.visible = false
  bugs_menu.visible = false
  exclaim_menu.visible = false

func open_journal(i: int) -> void:
  play_sfx("res://assets/Sounds/Library Foliant G Clipped.wav")
  get_tree().paused = true
  reset_journal()
  if i == 1:
    settings_tab.z_index = 0
    settings_menu.visible = true
  elif i == 2:
    bugs_tab.z_index = 0
    bugs_menu.visible = true
  elif i ==3:
    exclaim_tab.z_index = 0
    exclaim_menu.visible = true

  if not open:
    open = true
    animation_player.play("slide")
    await animation_player.animation_finished

func close_journal() -> void:
  open = false
  play_sfx("res://assets/Sounds/Library Foliant A.wav")
  animation_player.play_backwards("slide")
  await animation_player.animation_finished
  reset_journal()
  get_tree().paused = false

func build_bug_menu(bug_counts:Dictionary) -> void:
  # bug_collection = {Bug: Int, Bug: Int}

  # erase any existing stuffs
  for child in bugs_menu_vbox.get_children(): child.queue_free()

  # preload bug_tally to instanciate
  var load_bug_tally:PackedScene = preload("res://src/ui/bug_tally.tscn")

  # create first hbox to hold first row of collection
  var current_row = HBoxContainer.new()
  bugs_menu_vbox.add_child(current_row)

  # keep track of current column #
  var current_col = 0

  # iterate through collection
  for bug_type in bug_counts.keys():
    current_col += 1

    if current_col == 6:
      # create new row hbox
      current_row = HBoxContainer.new()
      bugs_menu_vbox.add_child(current_row)
      # reset current_col
      current_col = 1

    # add bug button to current row
    var new_bug_tally = load_bug_tally.instantiate()
    current_row.add_child(new_bug_tally)
    new_bug_tally.load_tallies(bug_type, bug_counts[bug_type])

    # connect bug tally signal
    new_bug_tally.connect("bug_tally_pressed", on_bug_tally_pressed)

  open_journal(2)

func build_exclaim_menu() -> void:
  
  var colors = {"Normal": Color.WHITE, "Alert": Color(100, 0, 0)}
  var positions = {"Mon": Vector2(-73, 21), "Tue": Vector2(-55, 23), "Wed": Vector2(-32, 24), "Thu": Vector2(-3, 26), \
                    "Fri": Vector2(17, 24), "Sat": Vector2(-40, 70), "Sun": Vector2(-42,103)}
  var current_day:String = get_tree().current_scene.time.current_day
  var cirlce_position = positions[current_day]
  
  day_highlighter.position = cirlce_position
  if current_day.contains("S"): day_highlighter.modulate = colors["Alert"]
  else: day_highlighter.modulate = colors["Normal"]


#region events
# hovers
func _on_settings_mouse_entered() -> void: hovering = true
func _on_bugs_mouse_entered() -> void: hovering = true
func _on_exclaim_mouse_entered() -> void: hovering = true

func _on_settings_mouse_exited() -> void: hovering = false
func _on_bugs_mouse_exited() -> void: hovering = false
func _on_exclaim_mouse_exited() -> void: hovering = false

# clicks
func _on_settings_pressed() -> void:
  open_journal(1)

func _on_bugs_pressed() -> void:
  #var bug_collection = {BugBuilder.new().ant().shiny().normalize_stats().build(): 16, BugBuilder.new().slug().shiny().normalize_stats().build(): 7, BugBuilder.new().ladybug().shiny().normalize_stats().build(): 1,BugBuilder.new().ant().shiny().normalize_stats().build(): 16, BugBuilder.new().slug().shiny().normalize_stats().build(): 7, BugBuilder.new().ladybug().shiny().normalize_stats().build(): 1,BugBuilder.new().ant().shiny().normalize_stats().build(): 16, BugBuilder.new().slug().shiny().normalize_stats().build(): 7, BugBuilder.new().ladybug().shiny().normalize_stats().build(): 1}
  build_bug_menu(get_tree().current_scene.player.bug_counts)

func _on_exclaim_pressed() -> void:
  build_exclaim_menu()
  open_journal(3)

func _on_quit_pressed() -> void: emit_signal("exit_game")
#endregion


func _on_delete_this_button_pressed() -> void:
  var new_vendor = load("res://src/ui/vendor.tscn").instantiate()
  add_child(new_vendor)
  new_vendor.load_inventory(get_tree().current_scene.player.bug_inventory)
