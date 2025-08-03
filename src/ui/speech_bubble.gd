class_name SpeechBubble
extends Control

# @onready var _anchor_container := $%AnchorContainer
# @onready var _left_tail := $%TailLeft
# @onready var _right_tail := $%TailRight
@onready var _text_label := $%Text
@onready var _next_icon := $%NextIcon

enum AnchorSide {
  LEFT,
  RIGHT
}

# func set_bubble_state(anchor_side: AnchorSide, is_floating := false) -> void:
  # match anchor_side:
  #   AnchorSide.LEFT:
  #     _anchor_container.set_anchors_preset(Control.PRESET_BOTTOM_LEFT, true)
  #     _left_tail.visible = true
  #   AnchorSide.RIGHT:
  #     _anchor_container.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT, true)
  #     _left_tail.visible = false
  #   _:
  #     printerr("unrecognized or unsupported anchor side")
    
  # if is_floating:
  #   _right_tail.visible = false
  # else:
  #   _right_tail.visible = !_left_tail.visible
  # _anchor_container.queue_redraw()

# func add_dialogue_lines(lines: Array[String]):
#   pass

func set_label_text(text: String):
  _text_label.text = text

func set_next_icon_visible(value: bool): _next_icon.visible = value

# TODO
# needs signals for when dialogue has been fully written
# needs indicator that more dialogue is comin
# probably animate text speed?
#     config setting for text speed (slow / mid / fast / instant)
# needs to receive  dialogue
# needs to listen for input to advance dialogue
#     touch / any key / click
#
