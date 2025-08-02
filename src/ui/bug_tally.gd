extends VBoxContainer
# This is used in the Notebook menu
# and displays count info for one collection of bugs

signal bug_tally_pressed

@onready var texture_rect_doodle = $TextureRectDoodle
@onready var rtl_bug_name = $RTLBugName
@onready var vbox_container_tallies = $VBoxContainerTallies
@onready var preload_tallies:PackedScene = preload("res://src/ui/tallies.tscn")
 
@onready var loaded_bug_stats:BugStats = null

func _ready() -> void:
  #load_tallies(BugBuilder.new().ant().shiny().normalize_stats().build(), 12)
  pass

func load_tallies(stats:BugStats, count:int):
  if not stats or count < 1: return
  
  # assigned loaded bug to pass with signal
  loaded_bug_stats = stats
  
  var doodle_path = ""
  var split = stats.bug_stats.texture_path.split("/")
  var i = 0
  
  # deconstruct the texture path and prepend "doodle_" to the filename
  for part in split:
    i += 1
    if i == split.size(): part = "doodle_" + part
    doodle_path += part  
    if i < split.size(): doodle_path += "/"
  
  texture_rect_doodle.texture = load(doodle_path)
  rtl_bug_name.text = "[b]" + stats.bug_name.strip_edges()

  if count >= 20:
    pass
    # just make 4 full tallies
  else:
    var number_leftover_tallies = (count % 5)
    var number_full_tallies = (count - number_leftover_tallies) / 5
    
    # create first hbox to hold first row of inventory
    var current_row = HBoxContainer.new()
    vbox_container_tallies.add_child(current_row)
  
    # keep track of current column #
    var current_col = 0
    
    # do all the full tallies first
    for n in number_full_tallies:
      current_col += 1

      if current_col == 3:
        # create new row hbox
        current_row = HBoxContainer.new()
        vbox_container_tallies.add_child(current_row)
        # reset current_col
        current_col = 1
    
      # add tallie object to current row
      var new_tallies = preload_tallies.instantiate()
      current_row.add_child(new_tallies)
      
      # set the sprite to frame 4 which is a full 5 tallies
      new_tallies.find_child("AnimatedSprite2D").frame = 4
    
    # check if we're already on the last column
    if current_col == 2:
        # create new row hbox
        current_row = HBoxContainer.new()
        vbox_container_tallies.add_child(current_row)
        
    # add the leftover tallies
    var leftover_tallies = preload_tallies.instantiate()
    current_row.add_child(leftover_tallies)
    leftover_tallies.find_child("AnimatedSprite2D").frame = number_leftover_tallies - 1


func _on_gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton:
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
      if loaded_bug_stats: emit_signal("bug_tally_pressed", loaded_bug_stats)
