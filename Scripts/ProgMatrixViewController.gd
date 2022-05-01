extends Node2D

signal matrix_entry_mouse_entered
signal matrix_entry_mouse_exited
signal matrix_entry_mouse_down

var MatrixEntry = preload("res://MatrixEntry.tscn")
var MatrixBlankPrefab = preload("res://MatrixBlank.tscn")

var matrix = null
var matrixProgs = []
var matrixEntries = []

func setup(progMatrix):
	matrix = progMatrix
	
	update_tiles()
			
	for x in range(matrix.width):
		var entry = MatrixEntry.instance()
		entry.connect("mouse_entered", self, "_matrix_entry_mouse_entered")
		entry.connect("mouse_exited", self, "_matrix_entry_mouse_exited")
		entry.connect("mouse_down", self, "_matrix_entry_mouse_down")
		add_child(entry)
		matrixEntries.push_back(entry)
		entry.transform.origin = coord_to_pos(x, -1)
		
		entry = MatrixEntry.instance()
		entry.connect("mouse_entered", self, "_matrix_entry_mouse_entered")
		entry.connect("mouse_exited", self, "_matrix_entry_mouse_exited")
		entry.connect("mouse_down", self, "_matrix_entry_mouse_down")
		add_child(entry)
		matrixEntries.push_back(entry)
		entry.transform.origin = coord_to_pos(x, matrix.height)
	
	for y in range(matrix.height):
		var entry = MatrixEntry.instance()
		entry.connect("mouse_entered", self, "_matrix_entry_mouse_entered")
		entry.connect("mouse_exited", self, "_matrix_entry_mouse_exited")
		entry.connect("mouse_down", self, "_matrix_entry_mouse_down")
		add_child(entry)
		matrixEntries.push_back(entry)
		entry.transform.origin = coord_to_pos(-1, y)
		
		entry = MatrixEntry.instance()
		entry.connect("mouse_entered", self, "_matrix_entry_mouse_entered")
		entry.connect("mouse_exited", self, "_matrix_entry_mouse_exited")
		entry.connect("mouse_down", self, "_matrix_entry_mouse_down")
		add_child(entry)
		matrixEntries.push_back(entry)
		entry.transform.origin = coord_to_pos(matrix.width, y)

func update_tiles():
	for prog in matrixProgs:
		remove_child(prog)
	matrixProgs.clear()
	
	for x in range(matrix.width):
		for y in range(matrix.height):
			var prog = matrix.get_instruction(x,y)
			if prog == null:
				prog = MatrixBlankPrefab.instance()
			add_child(prog)
			matrixProgs.push_back(prog)
			prog.transform.origin = coord_to_pos(x,y)

func show_card_slots():
	for entry in matrixEntries:
		entry.show_card_slot()
	
func show_run_starts():
	for entry in matrixEntries:
		entry.show_run_start()

func coord_to_pos (x, y) -> Vector2:
	return Vector2(x*32,y*32)
	
func pos_to_coord (x, y) -> Vector2:
	return Vector2(x/32,y/32)

func _matrix_entry_mouse_entered(matrixEntry):
	emit_signal("matrix_entry_mouse_entered", matrixEntry)

func _matrix_entry_mouse_exited(matrixEntry):
	emit_signal("matrix_entry_mouse_exited", matrixEntry)
	
func _matrix_entry_mouse_down(matrixEntry):
	emit_signal("matrix_entry_mouse_down", matrixEntry)
	
func insert_prog(prog, matrixEntry):
	var insert_point = pos_to_coord(matrixEntry.transform.origin.x, matrixEntry.transform.origin.y)
	insert_progv(prog, insert_point)
		
func insert_progv(prog, insert_point):
	matrix.insert_prog(prog, insert_point)
	update_tiles()

func run(matrixEntry):
	var insert_point = pos_to_coord(matrixEntry.transform.origin.x, matrixEntry.transform.origin.y)
	matrix.run(insert_point)
