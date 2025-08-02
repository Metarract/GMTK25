extends Node2D

@onready var player = get_tree().current_scene.player

@onready var sprite:Sprite2D = $Sprite
@onready var bug_inventory_hbox:HBoxContainer = $CanvasLayer/PanelContainer/VBoxContainer/BugInventory/ScrollContainer/HBoxContainer
@onready var sell_all_value:RichTextLabel = $CanvasLayer/PanelContainer/VBoxContainer/LowerBar/HBoxContainer/SellAllValue

var preload_inventory_button = preload("res://src/ui/bug_inventory_button.tscn")

func load_inventory(bug_stats:Array) -> void:
  if not bug_stats: return
  if bug_stats.size() <1: return
  
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
    
  sell_all_value.text = "(" + str(val) + ")"
  
func load_dialogue() -> void:
  pass
    
func sell_bug(b:BugStats) -> void:
  player.currency += b.trade_value
  player.bug_inventory.erase(b)
  load_inventory(player.bug_inventory)
  
func _on_sell_all_pressed() -> void:
  player.bug_inventory.clear()
  player.currency += int(sell_all_value.text)
  
func _on_say_goodbye_pressed() -> void:
  pass # Replace with function body.
  # queue_free() prolly?
