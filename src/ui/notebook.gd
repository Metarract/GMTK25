extends Node2D

var open:bool = false
var hovering:bool = false

var position_start_x:float = 535.0
var position_hover_x:float = 510.0
var position_open_x:float = 8.0
var lerp_weight = 7.5

@onready var animation_player = $AnimationPlayer

@onready var journal = $Journal
@onready var settings_tab = $Journal/SettingsTab
@onready var bugs_tab = $Journal/BugsTab
@onready var exclaim_tab = $Journal/ExclaimTab

@onready var settings_menu = $SettingsMenu
@onready var bugs_menu = $BugsMenu
@onready var exclaim_menu = $ExclaimMenu

func _on_area_2d_settings_mouse_entered() -> void: hovering = true
func _on_area_2d_bugs_mouse_entered() -> void: hovering = true
func _on_area_2d_exclaim_mouse_entered() -> void: hovering = true

func _on_area_2d_settings_mouse_exited() -> void: hovering = false
func _on_area_2d_bugs_mouse_exited() -> void: hovering = false
func _on_area_2d_exclaim_mouse_exited() -> void: hovering = false

func _process(delta: float) -> void:
  if not open:
    if hovering:
      if journal.position.x != position_hover_x:
        journal.position.x = lerp(journal.position.x, position_hover_x, lerp_weight * delta)
    else:
      if journal.position.x != position_start_x:
        journal.position.x =  lerp(journal.position.x, position_start_x, lerp_weight * delta)

func _on_button_pressed() -> void:
  # get rid of this button when we can get this to close properly
  close_journal()

#func _unhandled_input(event: InputEvent) -> void: 
#  if event is InputEventMouseButton:
#    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
#      if open: close_journal()
        
func reset() -> void:
  settings_tab.z_index = -10
  bugs_tab.z_index = -10
  exclaim_tab.z_index = -10
  
  settings_menu.visible = false
  bugs_menu.visible = false
  exclaim_menu.visible = false
  

func open_journal(i: int) -> void:
  
  reset()
  if i == 1: settings_tab.z_index = 0
  elif i == 2: bugs_tab.z_index = 0
  elif i ==3: exclaim_tab.z_index = 0
  
  if not open:
    open = true
    animation_player.play("slide")
    await animation_player.animation_finished
    
  if i == 1: settings_menu.visible = true
  elif i == 2: bugs_menu.visible = true
  elif i ==3: exclaim_menu.visible = true
    
func close_journal() -> void:
  open = false
  reset()
  animation_player.play_backwards("slide")

func _on_area_2d_settings_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed: 
      #get_viewport().set_input_as_handled()
      open_journal(1)
      
func _on_area_2d_bugs_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
      #get_viewport().set_input_as_handled()
     open_journal(2)
      
func _on_area_2d_exclaim_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
 if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed: 
      #get_viewport().set_input_as_handled()
      open_journal(3)
