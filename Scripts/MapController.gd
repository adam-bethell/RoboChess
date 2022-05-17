extends Node2D

signal player_clicked
signal map_clicked
signal player_hit
signal run_progs_finished
signal highlight_player_pos

var width = 16
var height = 13

func _ready():
	$Area2D.connect("input_event", self, "_on_input_event")
	$Area2D.connect("mouse_exited", self, "_mouse_exited")
	
func setup(level_data):
	for x in range(-1, width+1):
		for y in range(-1, height+1):
			$TileMap.set_cell(x, y, level_data.get_cell(x, y))

func get_player_map_positions():
	var player_positions = []
	for x in range(width):
		for y in range(height):
			var tile_id = $TileMap.get_cell(x, y)
			if tile_id == -1:
				continue
			var player_tile = $TileMap.get_tileset().tile_get_name(tile_id)
			if UnitData.is_unit_tile(player_tile):
				var info = [player_tile, Vector2(x,y)]
				player_positions.push_back(info)
	
	return player_positions

func run_progs(player, progs):
	for prog in progs:
		var player_tile_id = $TileMap.get_cellv(player.map_position)
		assert(player_tile_id != -1)
		var player_tile_name = $TileMap.get_tileset().tile_get_name(player_tile_id)
		var attack_tile_name = UnitData.find_unit_data_from_tile_name(player_tile_name)["attack_tile"]
		
		if prog.type == CardData.Type.MOVE:
			var move_vector = prog.direction_as_move_vector()
			var new_position = player.map_position + move_vector
			if $TileMap.get_cellv(new_position) == -1:
				$TileMap.set_cellv(player.map_position, -1)
				player.map_position = new_position
				$TileMap.set_cellv(player.map_position, player_tile_id)
					
		elif prog.type == CardData.Type.ATTACK:
			var attack_vectors = prog.direction_as_attack_vectors()
			for vector in attack_vectors:
				var attack_position = player.map_position + vector
				
				var tile_id = $TileMap.get_cellv(attack_position)
				if tile_id == -1:
					continue
				var player_tile = $TileMap.get_tileset().tile_get_name(tile_id)
				
				if UnitData.is_unit_tile(player_tile):
					emit_signal("player_hit", attack_position)
		
		else:
			if "dmg" in prog.keywords:
				emit_signal("player_hit", player.map_position)
				
	emit_signal("run_progs_finished")
	
func init_run(player):
	emit_signal("player_clicked", player.map_position)
	var matrix = player.get_matrix()
	var prog = matrix.next_prog()
	while not matrix.is_end_of_run():
		if prog != null:
			var player_tile_id = $TileMap.get_cellv(player.map_position)
			assert(player_tile_id != -1)
			var player_tile_name = $TileMap.get_tileset().tile_get_name(player_tile_id)
			var attack_tile_name = UnitData.find_unit_data_from_tile_name(player_tile_name)["attack_tile"]
			
			if prog.type == CardData.Type.MOVE:
				var move_vector = prog.direction_as_move_vector()
				var new_position = player.map_position + move_vector
				if $TileMap.get_cellv(new_position) == -1:
					$TileMap.set_cellv(player.map_position, -1)
					player.map_position = new_position
					$TileMap.set_cellv(player.map_position, player_tile_id)
					yield(get_tree().create_timer(0.4), "timeout")
						
			elif prog.type == CardData.Type.ATTACK:
				var attack_vectors = prog.direction_as_attack_vectors()
				for vector in attack_vectors:
					var attack_position = player.map_position + vector
					
					$Overlays.set_cellv(attack_position, $Overlays.get_tileset().find_tile_by_name(attack_tile_name))
					yield(get_tree().create_timer(0.2), "timeout")
					$Overlays.set_cellv(attack_position, -1)
					yield(get_tree().create_timer(0.2), "timeout")
					
					var tile_id = $TileMap.get_cellv(attack_position)
					if tile_id == -1:
						continue
					var player_tile = $TileMap.get_tileset().tile_get_name(tile_id)
					
					if UnitData.is_unit_tile(player_tile):
						emit_signal("player_hit", attack_position)
			
			else:
				if "dmg" in prog.keywords:
					$Overlays.set_cellv(player.map_position, $Overlays.get_tileset().find_tile_by_name(attack_tile_name))
					yield(get_tree().create_timer(0.2), "timeout")
					$Overlays.set_cellv(player.map_position, -1)
					yield(get_tree().create_timer(0.2), "timeout")
					emit_signal("player_hit", player.map_position)
				else:
					yield(get_tree().create_timer(0.4), "timeout")
		else:
			yield(get_tree().create_timer(0.4), "timeout")
		prog = matrix.next_prog()
		
	emit_signal("map_clicked")
	emit_signal("run_progs_finished")

func player_died(player):
	var pos = player.map_position
	var tile_id = $TileMap.get_cellv(pos)
	assert(tile_id != -1)
	var tile = $TileMap.get_tileset().tile_get_name(tile_id)
	assert(UnitData.is_unit_tile(tile))
	$TileMap.set_cellv(pos, -1)

func _on_input_event(_viewport, _event, _shape_idx):
	var mouse_pos = get_global_mouse_position()
	var map_pos = $TileMap.world_to_map(mouse_pos)
	map_pos = map_pos + Vector2(-2, -3)
	var tile_id = $TileMap.get_cellv(map_pos)
	var is_player_tile = false
	var tile_name = ""
	if tile_id != -1:
		tile_name = $TileMap.get_tileset().tile_get_name(tile_id)
		is_player_tile = UnitData.is_unit_tile(tile_name)
	
	if Input.is_action_just_pressed("click"):
		if is_player_tile:
			emit_signal("player_clicked", map_pos)
		else:
			emit_signal("map_clicked")
	else:
		if is_player_tile:
			highlight(map_pos)
			emit_signal("highlight_player_pos", map_pos)
			var unit_data = UnitData.find_unit_data_from_tile_name(tile_name)
			Globals.emit_signal("info_bus", self, unit_data["name"])
		else:
			unhighlight_all()
			emit_signal("highlight_player_pos", null)
			Globals.emit_signal("info_bus", self, null)

func _mouse_exited():
	unhighlight_all()
	emit_signal("highlight_player_pos", null)
	Globals.emit_signal("info_bus", self, null)

func get_distance(start, goal):
	var route = get_route(start, goal)
	if route == null:
		return 9999
	return route.size()
	
func get_route(start, goal):
	var frontier = []
	frontier.push_front([start, 0])
	var came_from = {}
	var cost_so_far = {}
	came_from[start] = null
	cost_so_far[start] = 0
	
	var current = null
	while not frontier.empty():
		current = _frontier_get_lowest_priority(frontier)
		
		if current == goal:
			break
			
		for next in get_neighbors(current, goal):
			var new_cost = cost_so_far[current] + 1
			if not cost_so_far.has(next) || new_cost < cost_so_far[next]:
				cost_so_far[next] = new_cost
				var priority = new_cost + abs(goal.distance_to(next))
				frontier.push_back([next, priority])
				came_from[next] = current

	if current != goal:
		return null

	var path = []
	while current != start:
		path.push_front(current)
		current = came_from[current]
	
	return path
			
func get_neighbors(current, goal):
	var neighbors = []
	
	for move in [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]:
		var neighbor = current + move
		if $TileMap.get_cellv(neighbor) == -1 || neighbor == goal:
			neighbors.push_back(neighbor)
			
	return neighbors
	
func _frontier_get_lowest_priority(frontier: Array):
	var index = -1
	var val = 9999
	
	for i in frontier.size():
		if frontier[i][1] < val:
			val = frontier[i][1]
			index = i
			
	assert(index != -1)
	
	var out = frontier[index]
	frontier.remove(index)
	return out[0]
	
func unhighlight_all():
	for cell in $Overlays.get_used_cells_by_id($Overlays.get_tileset().find_tile_by_name("Highlight")):
		$Overlays.set_cellv(cell, -1)
	
func highlight (map_pos):
	unhighlight_all()
	$Overlays.set_cellv(map_pos, $Overlays.get_tileset().find_tile_by_name("Highlight"))
	
