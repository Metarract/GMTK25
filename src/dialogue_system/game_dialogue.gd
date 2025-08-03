@static_unload
class_name GameDialogue
extends Node

const VENDOR_COUNT := 3

static var PATCHY_PCK: PackedScene = preload("res://src/dialogue_system/characters/patchy.tscn")
static var WORMFRIEND_PCK: PackedScene = preload("res://src/dialogue_system/characters/wormfriend.tscn")
static var ZEB_N_CO_PCK: PackedScene = preload("res://src/dialogue_system/characters/zeb_n_co.tscn")

static func get_patchy() -> CharacterCard: return PATCHY_PCK.instantiate()
static func get_wormfriend() -> CharacterCard: return WORMFRIEND_PCK.instantiate()
static func get_zebnco() -> CharacterCard: return ZEB_N_CO_PCK.instantiate()

## load resource
static func get_dialogue_set(resource_path: String) -> DialogueSet:
  var res = load(resource_path)
  if res is not DialogueSet:
    printerr("wat r u doin, that's not a dialogue resource")
    return null
  return res

#region individual dialogues
#region wormfriend dialogue
# static func wormfriend_first_meeting() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/patchy_first_meeting.tres")
static func wormfriend_meetings() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/wormfriend_meetings.tres")
static func wormfriend_sale() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/wormfriend_sale.tres")
#endregion

#region patchy dialogue
static func patchy_first_meeting() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/patchy_first_meeting.tres")
static func patchy_meetings() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/patchy_meetings.tres")
static func patchy_sale() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/patchy_sale.tres")
#endregion

#region zeb n co dialogue
static func zebnco_first_meeting() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/zebnco_first_meeting.tres")
static func zebnco_meetings() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/zebnco_meetings.tres")
static func zebnco_sale() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/zebnco_sales.tres")
#endregion
#endregion