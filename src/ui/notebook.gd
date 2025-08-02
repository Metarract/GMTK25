extends Node2D

signal journal_opened
signal journal_closed
signal exit_game

var audio_pitch_variation:float = 0.2

var open:bool = false
var hovering:bool = false

var position_start_x:float = 535.0
var position_hover_x:float = 510.0
var position_open_x:float = 8.0
var lerp_weight = 7.5

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

func _on_area_2d_settings_mouse_entered() -> void: hovering = true
func _on_area_2d_bugs_mouse_entered() -> void: hovering = true
func _on_area_2d_exclaim_mouse_entered() -> void: hovering = true

func _on_area_2d_settings_mouse_exited() -> void: hovering = false
func _on_area_2d_bugs_mouse_exited() -> void: hovering = false
func _on_area_2d_exclaim_mouse_exited() -> void: hovering = false

func _on_quit_pressed() -> void: emit_signal("exit_game")

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

func on_bug_tally_pressed(b:Bug) -> void:
  play_sfx("res://assets/Sounds/Library Foliant G Clipped.wav")
  stats_graph_container.visible = true  
  stats_graph.set_bug_stats(b.bug_stats)

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
  emit_signal("journal_opened")
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
  emit_signal("journal_closed")

func build_bug_menu(bug_collection:Dictionary) -> void:

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
  for bug in bug_collection.keys():
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
    new_bug_tally.load_tallies(bug, bug_collection[bug])
    
    # connect bug tally signal
    new_bug_tally.connect("bug_tally_pressed", on_bug_tally_pressed)
  
  # bug_collection = {Bug: Int, Bug: Int}
  open_journal(2)

func _on_area_2d_settings_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed: 
      #get_viewport().set_input_as_handled()
      open_journal(1)
      
func _on_area_2d_bugs_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
      #get_viewport().set_input_as_handled()
      var bug_collection = {BugBuilder.new().ant().shiny().normalize_stats().build(): 16, BugBuilder.new().slug().shiny().normalize_stats().build(): 7, BugBuilder.new().ladybug().shiny().normalize_stats().build(): 1,BugBuilder.new().ant().shiny().normalize_stats().build(): 16, BugBuilder.new().slug().shiny().normalize_stats().build(): 7, BugBuilder.new().ladybug().shiny().normalize_stats().build(): 1,BugBuilder.new().ant().shiny().normalize_stats().build(): 16, BugBuilder.new().slug().shiny().normalize_stats().build(): 7, BugBuilder.new().ladybug().shiny().normalize_stats().build(): 1}
      build_bug_menu(bug_collection)
      
func _on_area_2d_exclaim_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
 if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed: 
      #get_viewport().set_input_as_handled()
      open_journal(3)
