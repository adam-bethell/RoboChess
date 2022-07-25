extends Node

signal prog_dropped
signal init_run
signal matrix_updated

var width: int
var height: int
var matrix: Array

var run_movement: Vector2
var run_position: Vector2
var run_prog = null
var run_ended = true

func setup(x, y):
	width = x
	height = y
	
	matrix.resize(width)
	for i in (width):
		var col: Array = []
		col.resize(height)
		matrix[i] = col
		
	for x in range(width):
		for y in range(height):
			matrix[x][y] = null

func start_insert_phase():
	pass
	
func activate_prog(prog):
	var position = get_position(prog)
	assert(position != null)
	
	prog.num_activations += 1
	
	if "stop" in prog.keywords:
		run_ended = true
	
	if "redirect" in prog.keywords:
		run_movement = prog.direction_as_move_vector()
	
	if "spin cw" in prog.keywords:
		var spin_dir = prog.spin_as_move_vector()
		var affected_pos = position + spin_dir
		if _is_valid_matrix_position(affected_pos) && matrix[affected_pos.x][affected_pos.y] != null:
			matrix[affected_pos.x][affected_pos.y].spin_cw()
		prog.spin_cw()
	elif "spin acw" in prog.keywords:
		var spin_dir = prog.spin_as_move_vector()
		var affected_pos = position + spin_dir
		if _is_valid_matrix_position(affected_pos) && matrix[affected_pos.x][affected_pos.y] != null:
			matrix[affected_pos.x][affected_pos.y].spin_acw()
		prog.spin_acw()
	
	if "swap ns" in prog.keywords || "swap ew" in prog.keywords:
		var swap_dir_1 = prog.direction_plus_spin(CardData.Direction.NORTH, prog.spin)
		var swap_dir_2 = prog.direction_plus_spin(CardData.Direction.SOUTH, prog.spin)
		if "swap ew" in prog.keywords:
			swap_dir_1 = prog.direction_plus_spin(swap_dir_1, CardData.Direction.EAST)
			swap_dir_2 = prog.direction_plus_spin(swap_dir_2, CardData.Direction.EAST)
		var swap_target_1 = position + prog.dir_value_as_move_vector(swap_dir_1)
		var swap_target_2 = position + prog.dir_value_as_move_vector(swap_dir_2)
		var swap_cell_1 = null
		var swap_cell_2 = null
		var swap_prog_1 = null
		var swap_prog_2 = null
		
		if _is_valid_matrix_position(swap_target_1):
			print("swap target 1 is valid")
			swap_cell_1 = swap_target_1
			if matrix[swap_cell_1.x][swap_cell_1.y] != null:
				print("swap cell 1 has prog")
				swap_prog_1 = matrix[swap_cell_1.x][swap_cell_1.y]
				matrix[swap_cell_1.x][swap_cell_1.y] = null
			
		if _is_valid_matrix_position(swap_target_2):
			swap_cell_2 = swap_target_2
			if matrix[swap_cell_2.x][swap_cell_2.y] != null:
				swap_prog_2 = matrix[swap_cell_2.x][swap_cell_2.y]
				matrix[swap_cell_2.x][swap_cell_2.y] = null
		
		if swap_prog_1 != null:
			if swap_cell_2 == null:
				drop_prog(swap_prog_1)
			else:
				matrix[swap_cell_2.x][swap_cell_2.y] = swap_prog_1
				
		if swap_prog_2 != null:
			if swap_cell_1 == null:
				drop_prog(swap_prog_2)
			else:
				print ("swap prog 2 swapped")
				matrix[swap_cell_1.x][swap_cell_1.y] = swap_prog_2
	
func drop_prog(prog):	
	emit_signal("prog_dropped", prog)
	
func clone():
	var clone = self.duplicate(7)
	clone.width = width
	clone.height = height
	clone.matrix = matrix.duplicate(true)
	return clone
		
func set_instruction (x: int, y: int, instruction):
	assert(x < width && x >= 0 && y < height && y >= 0)
	matrix[x][y] = instruction
	
func get_instruction (x: int, y: int):
	assert(x < width && x >= 0 && y < height && y >= 0)
	return matrix[x][y]

func get_position(prog):
	for x in range(width):
		for y in range(height):
			if matrix[x][y] == prog:
				return Vector2(x,y)
	return null

func get_insert_movement(insert_point):
	var movement = null
	if insert_point.x == -1:
		movement = Vector2(1,0)
	elif insert_point.x == width:
		movement = Vector2(-1,0)
	elif insert_point.y == -1:
		movement = Vector2(0,1)
	else:
		movement = Vector2(0,-1)
	return movement
		
func get_insert_start(insert_point):
	var start = null
	if insert_point.x == -1:
		start = Vector2(0, insert_point.y)
	elif insert_point.x == width:
		start = Vector2(width-1, insert_point.y)
	elif insert_point.y == -1:
		start = Vector2(insert_point.x, 0)
	else:
		start = Vector2(insert_point.x, height-1)
	return start
		
func insert_prog (new_prog, insert_point: Vector2):
	assert(new_prog != null && insert_point != null)
	
	new_prog.num_activations = 0
	
	var movement = get_insert_movement(insert_point)
	var position = get_insert_start(insert_point)
	
	var displaced_prog = new_prog
	
	while displaced_prog != null:
		var temp = matrix[position.x][position.y]
		matrix[position.x][position.y] = displaced_prog
		displaced_prog = temp
		
		if displaced_prog == null:
			break
		
		position = position + movement
		if position.x >= width || position.x < 0 || position.y >= height || position.y < 0:
			break;
			
	if displaced_prog != null:
		drop_prog(displaced_prog)
		return displaced_prog
	return null

func _is_valid_matrix_position(position):
	if position.x < width && position.x >= 0 && position.y < height && position.y >= 0:
		return true
	return false
	
func init_run(insert_point: Vector2):
	run_movement = get_insert_movement(insert_point)
	run_position = insert_point
	run_prog = null
	run_ended = false
	emit_signal("init_run")

func next_prog():
	run_position += run_movement
	
	if not _is_valid_matrix_position(run_position):
		run_ended = true
		emit_signal("matrix_updated")
		return null
	
	var prog = matrix[run_position.x][run_position.y]
	if prog != null:
		activate_prog(prog)
	emit_signal("matrix_updated")
	return prog
	
func is_end_of_run():
	return run_ended
	
func get_run(insert_point: Vector2):
	run_movement = get_insert_movement(insert_point)
	run_position = insert_point
	run_prog = null
	run_ended = false
	var counter = 0
	
	var progs = []
	var prog = next_prog()
	while not is_end_of_run():
		if prog != null:
			progs.push_back(prog)
		prog = next_prog()
		
		counter += 1
		if counter > 20:
			run_ended = true
	return progs
	
func get_insert_points():
	var insert_points = []
	for y in height:
		insert_points.push_back(Vector2(-1,y))
		insert_points.push_back(Vector2(width,y))
	for x in width:
		insert_points.push_back(Vector2(x,-1))
		insert_points.push_back(Vector2(x,height))
	return insert_points
	
func get_prog_count_by_type():
# warning-ignore:unused_variable
	var count_empty = 0
	var count_move = 0
	var count_attack = 0
	var count_debuff = 0
	
	for x in range(width):
		for y in range(height):
			var prog = matrix[x][y]
			if prog == null:
				count_empty += 1
			elif prog.type == CardData.Type.MOVE:
				count_move += 1
			elif prog.type == CardData.Type.ATTACK:
				count_attack += 1
			elif prog.type == CardData.Type.DEBUFF:
				count_debuff += 1
	return {
		CardData.Type.MOVE: count_move,
		CardData.Type.ATTACK: count_attack,
		CardData.Type.DEBUFF: count_debuff,
	}
