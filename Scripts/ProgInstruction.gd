extends Node2D

var description
var type
var direction
var distance
var keywords
var spin

func setup(card_data):
	description = card_data["description"]
	type = card_data["type"]
	direction = card_data["direction"]
	distance = card_data["distance"]
	keywords = card_data["keywords"]
	
	if "spin cw" in keywords:
		set_spin(randi() % 4)
	else:
		set_spin(CardData.Direction.NORTH)

	var tiles = card_data["tiles"]
	$TileMap.set_cell(-1,-1,$TileMap.get_tileset().find_tile_by_name(tiles[0]))
	$TileMap.set_cell(0,-1,$TileMap.get_tileset().find_tile_by_name(tiles[1]))
	$TileMap.set_cell(-1,0,$TileMap.get_tileset().find_tile_by_name(tiles[2]))
	$TileMap.set_cell(0,0,$TileMap.get_tileset().find_tile_by_name(tiles[3]))
	
	$Area2D.connect("mouse_entered", self, "identify")
	$Area2D.connect("mouse_exited", self, "clear_info")

func _calc_direction():
	return direction_plus_spin(direction, spin)

func direction_plus_spin(d, s):
	if d == CardData.Direction.ALL:
		return d
	elif s == CardData.Direction.NORTH:
		return d
	elif d == CardData.Direction.NORTH:
		return s
	elif s == CardData.Direction.SOUTH:
		if d == CardData.Direction.SOUTH:
			return CardData.Direction.NORTH
		elif d == CardData.Direction.EAST:
			return CardData.Direction.WEST
		elif d == CardData.Direction.WEST:
			return CardData.Direction.EAST
	elif s == CardData.Direction.EAST:
		if d == CardData.Direction.SOUTH:
			return CardData.Direction.WEST
		elif d == CardData.Direction.EAST:
			return CardData.Direction.SOUTH
		elif d == CardData.Direction.WEST:
			return CardData.Direction.NORTH
	elif s == CardData.Direction.WEST:
		if d == CardData.Direction.SOUTH:
			return CardData.Direction.EAST
		elif d == CardData.Direction.EAST:
			return CardData.Direction.NORTH
		elif d == CardData.Direction.WEST:
			return CardData.Direction.SOUTH

func direction_as_move_vector():
	return dir_value_as_move_vector(_calc_direction())
	
func spin_as_move_vector():
	return dir_value_as_move_vector(spin)
	
func dir_value_as_move_vector(dir):
	var move_vector = Vector2.ZERO
	if dir == CardData.Direction.NORTH:
		move_vector = Vector2(0, -1)
	elif dir == CardData.Direction.SOUTH:
		move_vector = Vector2(0, 1)
	elif dir == CardData.Direction.EAST:
		move_vector = Vector2(1, 0)
	elif dir == CardData.Direction.WEST:
		move_vector = Vector2(-1, 0)
	return move_vector
	
func direction_as_attack_vectors():
	var vectors = []

	for i in range(1,distance+1):
		if _calc_direction() == CardData.Direction.NORTH:
			vectors.push_back(Vector2(0, i * -1))
		elif _calc_direction() == CardData.Direction.SOUTH:
			vectors.push_back(Vector2(0, i))
		elif _calc_direction() == CardData.Direction.EAST:
			vectors.push_back(Vector2(i, 0))
		elif _calc_direction() == CardData.Direction.WEST:
			vectors.push_back(Vector2(i * -1, 0))
		elif _calc_direction() == CardData.Direction.ALL:
			vectors.push_back(Vector2(0, i * -1))
			vectors.push_back(Vector2(0, i))
			vectors.push_back(Vector2(i, 0))
			vectors.push_back(Vector2(i * -1, 0))

	return vectors

func set_spin(spin_dir):
	spin = spin_dir
	if spin == CardData.Direction.NORTH:
		$TileMap.rotation_degrees = 0
	elif spin == CardData.Direction.SOUTH:
		$TileMap.rotation_degrees = 180
	elif spin == CardData.Direction.EAST:
		$TileMap.rotation_degrees = 90
	elif spin == CardData.Direction.WEST:
		$TileMap.rotation_degrees = 270
		
func spin_cw():
	if spin == CardData.Direction.NORTH:
		set_spin(CardData.Direction.EAST)
	elif spin == CardData.Direction.SOUTH:
		set_spin(CardData.Direction.WEST)
	elif spin == CardData.Direction.EAST:
		set_spin(CardData.Direction.SOUTH)
	elif spin == CardData.Direction.WEST:
		set_spin(CardData.Direction.NORTH)
		
func spin_acw():
	if spin == CardData.Direction.NORTH:
		set_spin(CardData.Direction.WEST)
	elif spin == CardData.Direction.SOUTH:
		set_spin(CardData.Direction.EAST)
	elif spin == CardData.Direction.EAST:
		set_spin(CardData.Direction.NORTH)
	elif spin == CardData.Direction.WEST:
		set_spin(CardData.Direction.SOUTH)
		
func identify():
	Globals.emit_signal("info_bus", self, description)
func clear_info():
	Globals.emit_signal("info_bus", self, null)
