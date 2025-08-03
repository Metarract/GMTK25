class_name Vendor
extends Node2D

signal vendor_closed()

var preload_inventory_button = preload("res://src/ui/bug_inventory_button.tscn")

@onready var player:Player = get_tree().current_scene.player
@onready var audio_controller:AudioController = get_tree().current_scene.audio_controller

@onready var bug_inventory_hbox: HBoxContainer = $%BugHBoxContainer
@onready var current_cash: RichTextLabel = $%CurrentCash
@onready var sell_all_button: Button = $%SellAll

@export var dialogue_controller: DialogueController
@export var sell_window: Control

var sell_all_value: int = 0
var hovering_sell_all: bool = false

var current_vendor_index := 0
var sell_interaction_triggered := false

func _on_sell_all_mouse_entered() -> void: hovering_sell_all = true
func _on_sell_all_mouse_exited() -> void: hovering_sell_all = false

func _ready() -> void:
  z_as_relative = false
  z_index = 999
  sell_window.visible = false
  current_vendor_index = get_random_vendor_index()
  get_initial_dialogue()

func _process(delta: float) -> void:
  if hovering_sell_all: sell_all_button.text = "($%d)" % [sell_all_value]
  else: sell_all_button.text = "Sell All"

func load_inventory(bug_stats: Array) -> void:
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

func sell_bug(b: BugStats) -> void:
  get_sale_dialogue()
  player.currency += b.trade_value
  player.bug_inventory.erase(b)
  audio_controller.play_coins()
  load_inventory(player.bug_inventory)

func _on_sell_all_pressed() -> void:
  get_sale_dialogue()
  player.currency += sell_all_value
  player.bug_inventory.clear()
  audio_controller.play_coins()
  load_inventory(player.bug_inventory)

func _on_say_goodbye_pressed() -> void:
  vendor_closed.emit()
  queue_free() # prolly?

#region dialogue handlers
var vendor_index = {
  0: "patchy",
  1: "wormfriend",
  2: "zebnco"
}

func get_random_vendor_index() -> int: 
  var rand_index = player.last_vendor_index
  while rand_index == player.last_vendor_index:
    rand_index = randi_range(0, vendor_index.values().size()-1)
  player.last_vendor_index = rand_index
  return rand_index

func get_initial_dialogue():
  match current_vendor_index:
    0:
      # 9patches
      if player.patchy_has_met:
        sell_window.visible = true
        dialogue_controller.awake(GameDialogue.get_patchy(), GameDialogue.patchy_meetings())
      else:
        dialogue_controller.dialogue_completed.connect(on_first_meeting_completed)
        player.patchy_has_met = true
        dialogue_controller.awake(GameDialogue.get_patchy(), GameDialogue.patchy_first_meeting())
    1:
      # wormfriend
      sell_window.visible = true
      dialogue_controller.awake(GameDialogue.get_wormfriend(), GameDialogue.wormfriend_meetings())
    2:
      # zebnco
      if player.zebnco_has_met:
        sell_window.visible = true
        dialogue_controller.awake(GameDialogue.get_zebnco(), GameDialogue.zebnco_meetings())
      else:
        player.zebnco_has_met = true
        dialogue_controller.dialogue_completed.connect(on_first_meeting_completed)
        dialogue_controller.awake(GameDialogue.get_zebnco(), GameDialogue.zebnco_first_meeting())
      pass
  dialogue_controller._get_next_line()

func get_sale_dialogue():
  if sell_interaction_triggered: return
  sell_interaction_triggered = true
  match current_vendor_index:
    0:
      dialogue_controller.set_new_dialogue(GameDialogue.patchy_sale())
    1:
      dialogue_controller.set_new_dialogue(GameDialogue.wormfriend_sale())
    2:
      dialogue_controller.set_new_dialogue(GameDialogue.zebnco_sale())
  dialogue_controller._get_next_line()

# generic fuckin whatever
func on_first_meeting_completed():
  sell_window.visible = true
#endregion
