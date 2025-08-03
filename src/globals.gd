extends Node

#region mice icons
const MOUSE_ICON_SIZE = Vector2(64, 64)
const MOUSE_POINT_HOTSPOT = Vector2(45, 32)
const MOUSE_SHADOW_HOTSPOT = Vector2(32, 32)
const MOUSE_GRAB_HOTSPOT = Vector2(32, 32)

var mouse_point = load("res://assets/Sprites/Cursors/cursor_pointer.png")
var mouse_pen_shadow = load("res://assets/Sprites/Cursors/cursor_penshadow.png")
var mouse_grab_hand = load("res://assets/Sprites/Cursors/cursor_grabhand.png")
#endregion

func _ready() -> void:
  # set all of our mice icons :)
  Input.set_custom_mouse_cursor(mouse_point, Input.CURSOR_ARROW, MOUSE_POINT_HOTSPOT)
  Input.set_custom_mouse_cursor(mouse_grab_hand, Input.CURSOR_DRAG, MOUSE_GRAB_HOTSPOT)
  Input.set_custom_mouse_cursor(mouse_pen_shadow, Input.CURSOR_CAN_DROP, MOUSE_SHADOW_HOTSPOT)
  #