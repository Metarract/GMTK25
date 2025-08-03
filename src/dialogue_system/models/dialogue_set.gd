class_name DialogueSet
extends Resource

signal on_next_line(line: String)
signal on_dialogue_done()
signal on_next_set(dialogue: DialogueSet)

@export var emotion: CharacterCard.Emotions
@export var _lines: Array[String]
@export var next_dialogue: DialogueSet
@export var randomizable: bool = false

func next() -> bool:
  if _lines.size() == 0:
    return false
  if randomizable:
    var i = randi() % _lines.size()
    on_next_line.emit(_lines[i])
    _lines.clear()
  else:
    on_next_line.emit(_lines[0])
    _lines.remove_at(0)
  if _lines.size() == 0:
    on_dialogue_done.emit()
  return true

func next_set() -> bool:
  if next_dialogue == null: return false
  on_next_set.emit(next_dialogue)
  return true