extends Node2D

signal highlight_turn

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	$Area2D.connect("mouse_exited", self, "_mouse_exited")
	
func update_order(current_player, turn_order):
	$TileMap.clear()
	$TileMap.set_cell(1, 0, $TileMap.get_tileset().find_tile_by_name(current_player.player_tile))
	for i in range(turn_order.size()):
		var player = turn_order[i]
		$TileMap.set_cell(3+i, 1, $TileMap.get_tileset().find_tile_by_name(player.player_tile))
		
func _on_input_event(_viewport, _event, _shape_idx):
	var mouse_pos = get_global_mouse_position()
	var pos = $TileMap.world_to_map(mouse_pos)
	var tile_id = $TileMap.get_cellv(pos)
	if tile_id != -1:
		var position = clamp(pos.x-3, -1, 100)
		highlight(position)
		emit_signal("highlight_turn", position)
		var tile_name = $TileMap.get_tileset().tile_get_name(tile_id)
		if UnitData.is_unit_tile(tile_name):
			Globals.emit_signal("info_bus", self, UnitData.find_unit_data_from_tile_name(tile_name)["name"])
	else:
		Globals.emit_signal("info_bus", self, "The turn order")

func _mouse_exited():
	unhighlight_all()
	emit_signal("highlight_turn", null)
	Globals.emit_signal("info_bus", self, null)

func unhighlight_all():
	for cell in $Overlay.get_used_cells_by_id($Overlay.get_tileset().find_tile_by_name("Highlight")):
		$Overlay.set_cellv(cell, -1)

func highlight(position):
	unhighlight_all()
	if position == -1:
		$Overlay.set_cell(1, 0, $Overlay.get_tileset().find_tile_by_name("Highlight"))
	else:
		$Overlay.set_cell(3+position, 1, $Overlay.get_tileset().find_tile_by_name("Highlight"))
