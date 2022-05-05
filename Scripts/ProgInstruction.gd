extends Node2D

var description
var type
var direction
var distance
var keywords

func setup(card_data):
	description = card_data["description"]
	type = card_data["type"]
	direction = card_data["direction"]
	distance = card_data["distance"]
	keywords = card_data["keywords"]
	
	var tiles = card_data["tiles"]
	$TileMap.set_cell(0,0,$TileMap.get_tileset().find_tile_by_name(tiles[0]))
	$TileMap.set_cell(1,0,$TileMap.get_tileset().find_tile_by_name(tiles[1]))
	$TileMap.set_cell(0,1,$TileMap.get_tileset().find_tile_by_name(tiles[2]))
	$TileMap.set_cell(1,1,$TileMap.get_tileset().find_tile_by_name(tiles[3]))
	
	$Area2D.connect("mouse_entered", self, "identify")
	$Area2D.connect("mouse_exited", self, "clear_info")
	
func direction_as_move_vector():
	var move_vector = Vector2.ZERO
	if direction == CardData.Direction.NORTH:
		move_vector = Vector2(0, -1)
	elif direction == CardData.Direction.SOUTH:
		move_vector = Vector2(0, 1)
	elif direction == CardData.Direction.EAST:
		move_vector = Vector2(1, 0)
	elif direction == CardData.Direction.WEST:
		move_vector = Vector2(-1, 0)
	return move_vector
	
func direction_as_attack_vectors():
	var vectors = []

	for i in range(1,distance+1):
		if direction == CardData.Direction.NORTH:
			vectors.push_back(Vector2(0, i * -1))
		elif direction == CardData.Direction.SOUTH:
			vectors.push_back(Vector2(0, i))
		elif direction == CardData.Direction.EAST:
			vectors.push_back(Vector2(i, 0))
		elif direction == CardData.Direction.WEST:
			vectors.push_back(Vector2(i * -1, 0))
		elif direction == CardData.Direction.ALL:
			vectors.push_back(Vector2(0, i * -1))
			vectors.push_back(Vector2(0, i))
			vectors.push_back(Vector2(i, 0))
			vectors.push_back(Vector2(i * -1, 0))

	return vectors

func identify():
	Globals.emit_signal("info_bus", self, description)
func clear_info():
	Globals.emit_signal("info_bus", self, null)
