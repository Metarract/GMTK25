extends PanelContainer

@export var inventory = [] #Array of Bugs to be passed in to this scene

@onready var vbox_rows = $HBoxContent/InventoryPanel/VBoxRows
@onready var stats_panel = $HBoxContent/StatsPanel

func _ready() -> void:
	#var buggy1 = Bug.new("Bug", "A pretty normal bug.", "res://assets/Sprites/ant.png", 4.20, 2.0, 5.0)
	#var buggy2 = Bug.new("Icky Bug", "A very icky bug.", "res://assets/Sprites/ant.png", 6.9, 4.0, 10.0)
	#var buggy3 = Bug.new("Gross Bug", "A very gross bug.", "res://assets/Sprites/ant.png", 42.069, 6.0, 25.0)
	#var buggy4 = Bug.new("Icky Gross Bug", "A very gross and also icky bug.", "res://assets/Sprites/ant.png", 69.420, 8.0, 50.0)
	#inventory = [buggy1, buggy2, buggy3, buggy4]
	
	load_inventory(inventory)

func load_inventory(i:Array) -> bool:
	if i.size() < 1: return false
	
	# preload button to instanciate
	var load_bug_button:PackedScene = preload("res://src/ui/bug_inventory_button.tscn")
	
	# create first hbox to hold first row of inventory
	var current_row = HBoxContainer.new()
	vbox_rows.add_child(current_row)
	
	# keep track of current column #
	var current_col = 0
	
	# iterate through inventory
	for bug in inventory:
		current_col += 1

		if current_col == 4:
			# create new row hbox
			current_row = HBoxContainer.new()
			vbox_rows.add_child(current_row)
			# reset current_col
			current_col = 1
	
		# add bug button to current row
		var new_bug_button = load_bug_button.instantiate()
		current_row.add_child(new_bug_button)
		new_bug_button.assigned_bug = bug
		
		# connect bug button signal
		new_bug_button.connect("bug_inventory_button_pressed", bug_button_pushed)
		
	return true

func bug_button_pushed(b:Bug) -> bool:
	if not b: return false
	stats_panel.visible = true
	stats_panel.loadBug(b)
	return true
