extends Node2D

var preload_inventory_button = preload("res://src/ui/bug_inventory_button.tscn")

@onready var player:Player = get_tree().current_scene.player

@onready var sprite:Sprite2D = $Sprite
@onready var bug_inventory_hbox:HBoxContainer = $CanvasLayer/PanelContainer/VBoxContainer/BugInventory/ScrollContainer/HBoxContainer
@onready var current_cash:RichTextLabel = $CanvasLayer/PanelContainer/VBoxContainer/LowerBar/HBoxContainer/CurrentCash

@onready var sell_all_button:Button = $CanvasLayer/PanelContainer/VBoxContainer/LowerBar/HBoxContainer/SellAll
var sell_all_value:int = 0
var hovering_sell_all:bool = false

func _on_sell_all_mouse_entered() -> void: hovering_sell_all = true
func _on_sell_all_mouse_exited() -> void: hovering_sell_all = false

func _process(delta: float) -> void:
  if hovering_sell_all: sell_all_button.text = "($%d)" % [sell_all_value]
  else: sell_all_button.text = "Sell All"

func load_inventory(bug_stats:Array) -> void:
  
  # empty hbox
  for child in bug_inventory_hbox.get_children(): child.queue_free()
  
  # reset value to track for "sell all"
  var val = 0
  
  # add each bug from inventory
  for stats in bug_stats:
    var new_inventory_button = preload_inventory_button.instantiate()
    bug_inventory_hbox.add_child(new_inventory_button)
    new_inventory_button.assigned_bug_stats = stats
    new_inventory_button.connect("bug_inventory_button_pressed", sell_bug)
    val += stats.trade_value
    
  sell_all_value = val
  current_cash.text = "$%d" % [player.currency]
  
func load_dialogue() -> void:
  pass
    
func sell_bug(b:BugStats) -> void:
  player.currency += b.trade_value
  player.bug_inventory.erase(b)
  load_inventory(player.bug_inventory)
  
func _on_sell_all_pressed() -> void:
  player.currency += sell_all_value
  player.bug_inventory.clear()
  load_inventory(player.bug_inventory)
  
func _on_say_goodbye_pressed() -> void:
  queue_free() #prolly?
