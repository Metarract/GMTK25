extends Node2D

@onready var sprite:Sprite2D = $Sprite
@onready var bug_inventory_hbox:HBoxContainer = $CanvasLayer/PanelContainer/VBoxContainer/BugInventory/ScrollContainer/HBoxContainer
@onready var sell_all_value:RichTextLabel = $CanvasLayer/PanelContainer/VBoxContainer/LowerBar/HBoxContainer/SellAllValue

var preload_inventory_button = preload("res://src/ui/bug_inventory_button.tscn")

func load_inventory(bugs:Array) -> void:
  if not bugs: return
  if bugs.size() <1: return
  
  # empty hbox
  for child in bug_inventory_hbox.get_children(): child.queue_free()
  
  # reset value to track for "sell all"
  var val = 0
  
  # add each bug from inventory
  for bug in bugs:
    var new_inventory_button = preload_inventory_button.instantiate()
    bug_inventory_hbox.add_child(new_inventory_button)
    new_inventory_button.assigned_bug = bug
    new_inventory_button.connect("bug_inventory_button_pressed", sell_bug)
    val += bug.trade_value # might be bug.bug_stats.trade_value? depends on what data we're getting
    
  sell_all_value.text = "(" + str(val) + ")"
  
func load_dialogue() -> void:
  pass
    
func sell_bug(b:Bug) -> void:
  pass
  # player.money.add(bug.trade_value)
  # player.inventory.erase(bug)
  
func _on_sell_all_pressed() -> void:
  pass
  # player.inventory.clear()
  # player.money.add(int(sell_all_value.text))
  
func _on_say_goodbye_pressed() -> void:
  pass # Replace with function body.
  # queue_free() prolly?
