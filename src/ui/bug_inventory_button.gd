extends Button

signal bug_inventory_button_pressed

@onready var rich_text_label = $RichTextLabel

func _on_focus_entered() -> void: _on_mouse_entered()
func _on_focus_exited() -> void: _on_mouse_exited()
func _on_mouse_entered() -> void: rich_text_label.visible = true
func _on_mouse_exited() -> void: rich_text_label.visible = false
func _on_pressed() -> void: if assigned_bug: emit_signal("bug_inventory_button_pressed", assigned_bug)

var assigned_bug:BugStats:
  set(b):
    assigned_bug = b
    load_bug()

func load_bug() -> bool:
  if not assigned_bug: return false

  icon = load(assigned_bug.texture_path)
  add_theme_color_override("icon_normal_color", assigned_bug.color)
  rich_text_label.text = "$" + str(assigned_bug.trade_value)
  return true
