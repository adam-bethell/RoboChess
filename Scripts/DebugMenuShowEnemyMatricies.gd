extends CheckBox


func _ready():
	pressed = Settings.show_enemy_matracies
	connect("toggled", self, "_on_toggled")
	
func _on_toggled (value):
	print (value)
	Settings.show_enemy_matracies = value
