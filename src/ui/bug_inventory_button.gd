extends Button

signal bug_inventory_button_pressed

var assigned_bug:BugStats:
  set(b):
    assigned_bug = b
    load_bug()

func load_bug() -> bool:
  if not assigned_bug: return false

  icon = load(assigned_bug.texture_path)
  add_theme_color_override("icon_normal_color", assigned_bug.color)
  return true

func _on_pressed() -> void:
  if assigned_bug: emit_signal("bug_inventory_button_pressed", assigned_bug)
