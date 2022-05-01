extends Node

signal prog_dropped
signal run_progs

var width: int
var height: int
var matrix: Array

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
		emit_signal("prog_dropped", displaced_prog)
		return displaced_prog
	return null
		
func get_run(insert_point: Vector2):
	var movement = get_insert_movement(insert_point)
	var position = get_insert_start(insert_point)
	
	var progs = []
	while position.x < width && position.x >= 0 && position.y < height && position.y >= 0:
		var prog = matrix[position.x][position.y]
		if prog != null:
			progs.push_back(prog)
		position = position + movement
	
	return progs
	
func run(insert_point: Vector2):
	var progs = get_run(insert_point)
	emit_signal("run_progs", progs)
	
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
