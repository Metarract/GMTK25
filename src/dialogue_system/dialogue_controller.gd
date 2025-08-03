class_name DialogueController
extends Node2D

signal dialogue_completed()

var character_card: CharacterCard
var dialogue_set: DialogueSet
@export var speech_bubble: SpeechBubble

var is_awake := false

func _ready() -> void:
  awake(GameDialogue.get_patchy(), GameDialogue.patchy_first_meeting())
  _get_next_line()

func awake(char_card: CharacterCard, dialogue: DialogueSet):
  set_new_character(char_card, dialogue)
  is_awake = true

func set_new_character(char_card: CharacterCard, dialogue: DialogueSet):
  if character_card != null and !character_card.is_queued_for_deletion():
    character_card.queue_free()
  character_card = char_card
  add_child(character_card)
  set_new_dialogue(dialogue)

func set_new_dialogue(dialogue: DialogueSet):
  speech_bubble.set_next_icon_visible(true)
  dialogue_set = dialogue
  dialogue_set.on_next_line.connect(speech_bubble.set_label_text)
  dialogue_set.on_dialogue_done.connect(_on_dialogue_completed)
  dialogue_set.on_next_set.connect(_on_get_next_set)

  character_card.set_emotion(dialogue_set.emotion)

func _unhandled_input(_event: InputEvent) -> void:
  if !Input.is_action_just_pressed("advance_dialogue"): return
  _get_next_line()

func _get_next_line():
  if !is_awake: return
  var _res = dialogue_set.next()

func _on_dialogue_completed():
  var res = dialogue_set.next_set()
  if !res:
    dialogue_completed.emit()
    speech_bubble.set_next_icon_visible(false)

func _on_get_next_set(dialogue: DialogueSet):
  set_new_dialogue(dialogue)
