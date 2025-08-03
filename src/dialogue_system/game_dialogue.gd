@static_unload
class_name GameDialogue
extends Node

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
#endregion

#region patchy dialogue
static func patchy_first_meeting() -> DialogueSet: return get_dialogue_set("res://src/dialogue_system/dialogue_sets/patchy_first_meeting.tres")
#endregion

#region zeb n co dialogue
#endregion
#endregion