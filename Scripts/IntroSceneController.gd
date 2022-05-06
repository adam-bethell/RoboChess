extends Node2D

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	
func  _on_input_event (_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		queue_free()
