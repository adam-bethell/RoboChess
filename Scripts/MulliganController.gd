extends Node2D

signal mulligan

func _ready():
	$Area2D.connect("input_event", self, "_input_event")
	$Area2D.connect("mouse_entered", self, "_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_mouse_exited")
	
func _mouse_entered():
	if Globals.grabbed_prog == null:
		$HoverOverlay.visible = true
	
func _mouse_exited():
	$HoverOverlay.visible = false
	
func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("mulligan")
