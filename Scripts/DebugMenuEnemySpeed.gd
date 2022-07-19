extends HSlider


func _ready():
	value = Settings.enemy_turn_speed
	connect("value_changed", self, "_on_value_changed")	

func _on_value_changed(value):
	Settings.enemy_turn_speed = value
