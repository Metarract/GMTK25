extends PanelContainer

@onready var hslider_overall:HSlider = $VBoxContainer/VBoxContainer/HSliderOverall

func _ready():
  # set the Overall slider value to the value of the Master audio bus
  hslider_overall.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

func _on_h_slider_overall_value_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_button_exit_pressed() -> void:
  queue_free()
