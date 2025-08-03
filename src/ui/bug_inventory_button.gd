extends Button

signal bug_inventory_button_pressed

@onready var rich_text_label = $RichTextLabel

func _on_focus_entered() -> void: _on_mouse_entered()
func _on_focus_exited() -> void: _on_mouse_exited()
func _on_mouse_entered() -> void: rich_text_label.visible = true
func _on_mouse_exited() -> void: rich_text_label.visible = false
func _on_pressed() -> void: if assigned_bug_stats: emit_signal("bug_inventory_button_pressed", assigned_bug_stats)

var assigned_bug_stats:BugStats:
  set(b):
    assigned_bug_stats = b
    load_bug()

func load_bug() -> bool:
  if not assigned_bug_stats: return false

  icon = load(assigned_bug_stats.texture_path)
  add_theme_color_override("icon_normal_color", assigned_bug_stats.color)
  rich_text_label.text = "$%d" % [assigned_bug_stats.trade_value]
  return true
