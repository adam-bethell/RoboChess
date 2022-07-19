extends Node2D

signal count_updated

var count = 0
var card_data = null

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	$Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_on_mouse_exited")
	$Highlight.visible = false
	
func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action("click") && event.is_pressed() && not event.is_echo():
		count += 1
	elif event.is_action("context") && event.is_pressed() && not event.is_echo():
		count -= 1
			
	if count > 16:
		count = 0
	elif count < 0:
		count = 16
		
	_update_counter()

func _val_to_string(val):
	var text = String(val)
	if text.length() == 1:
		text = "0" + text
	return text
	
func _update_counter():
	var text = _val_to_string(count)
	$TileMap.set_cell(0,0,$TileMap.get_tileset().find_tile_by_name(text[0]))
	$TileMap.set_cell(1,0,$TileMap.get_tileset().find_tile_by_name(text[1]))
	
	emit_signal("count_updated", card_data, count)

func _on_mouse_entered():
	$Highlight.visible = true

func _on_mouse_exited():
	$Highlight.visible = false
