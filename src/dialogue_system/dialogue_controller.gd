class_name DialogueController
extends Node2D

const DIALOGUE_ADVANCEMENT_TIMEOUT_S = .2

signal dialogue_completed()

var character_card: CharacterCard
var dialogue_set: DialogueSet
@export var speech_bubble: SpeechBubble

var is_awake := false
var dialogue_advancement_timer := DIALOGUE_ADVANCEMENT_TIMEOUT_S

func awake(char_card: CharacterCard, dialogue: DialogueSet):
  is_awake = true
  set_new_character(char_card, dialogue)

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

func _process(delta: float) -> void:
  if dialogue_advancement_timer > 0: dialogue_advancement_timer -= delta

func _unhandled_input(_event: InputEvent) -> void:
  if !Input.is_action_just_pressed("advance_dialogue"): return
  if dialogue_advancement_timer > 0: return
  _get_next_line()
  dialogue_advancement_timer = DIALOGUE_ADVANCEMENT_TIMEOUT_S
  get_viewport().set_input_as_handled()

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
