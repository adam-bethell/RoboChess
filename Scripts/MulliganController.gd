extends Node2D

signal mulligan

func _ready():
	$Area2D.connect("input_event", self, "_input_event")
	$Area2D.connect("mouse_entered", self, "_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_mouse_exited")
	
func _mouse_entered():
	if Globals.grabbed_prog == null:
		$HoverOverlay.visible = true
	Globals.emit_signal("info_bus", self, "Discard hand and draw 3 new cards. Ends your turn")
	
func _mouse_exited():
	$HoverOverlay.visible = false
	Globals.emit_signal("info_bus", self, null)
	
func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("mulligan")
