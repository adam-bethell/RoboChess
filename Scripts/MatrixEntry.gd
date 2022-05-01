extends Node2D

signal mouse_down
signal mouse_entered
signal mouse_exited

func _ready():
	$Area2D.connect("input_event", self, "_input_event")
	$Area2D.connect("mouse_entered", self, "_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_mouse_exited")
	
func _mouse_entered():
	emit_signal("mouse_entered", self)
	
func _mouse_exited():
	emit_signal("mouse_exited", self)
	
func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("mouse_down", self)

func show_card_slot():
	$CardSlot.visible = true
	$RunStart.visible = false
	
func show_run_start():
	$CardSlot.visible = false
	$RunStart.visible = true
