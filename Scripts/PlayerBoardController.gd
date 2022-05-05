extends Node2D

signal run_progs
signal player_died

var is_human_player
var health = 1
var map_position = Vector2.ZERO
var ai = null
var player_tile = ""

func _ready():
	$Deck.connect("size_updated", $PlayerBoardUI, "set_deck_count")
	$Heap.connect("size_updated", $PlayerBoardUI, "set_heap_count")
	$Hand.connect("prog_added", $PlayerBoardUI, "add_to_hand")
	$Hand.connect("prog_removed", self, "draw_prog")
	$Matrix.connect("prog_dropped", $Heap, "add_to_heap")
	$Matrix.connect("run_progs", self, "run_progs")
	$PlayerBoardUI.connect("prog_played_from_hand", $Hand, "remove_prog")
	$PlayerBoardUI.connect("prog_played_from_hand", self, "prog_played")
	$PlayerBoardUI/Mulligan.connect("mulligan", self, "_on_mulligan")
	$PlayerBoardUI.set_health_val(health)
	
func setup(deck, _health, _map_position, matrix_x, matrix_y, tile, _ai):
	ai = _ai
	player_tile = tile
	if ai == null:
		is_human_player = true
	else:
		add_child(ai)
		ai.player = self
		ai.hand = $Hand
		ai.matrix = $Matrix
		is_human_player = false
		ai.connect("turn_calculated", self, "ai_process_turn_data")
	$PlayerBoardUI.setup(is_human_player, tile)
	# Player Info
	map_position = _map_position
	health = _health
	$PlayerBoardUI.set_health_val(health)
	# Matrix
	$Matrix.setup(matrix_x, matrix_y)
	$PlayerBoardUI/Board.setup($Matrix)
	# Deck
	for prog in deck:
		$Deck.add_prog(prog)
	$Deck.shuffle()
	# Hand
	for _i in range($Hand.get_limit() - $Hand.get_size()):
		$Hand.add_prog($Deck.draw())
		
func draw_prog():
	if $Deck.get_size() == 0:
		for prog in $Heap.take_progs():
			$Deck.add_prog(prog)
		$Deck.shuffle()
		damage()
	
	for _i in range($Hand.get_limit() - $Hand.get_size()):
		$Hand.add_prog($Deck.draw())

func start_turn():
	if not is_human_player:
		ai.calculate_turn()
	else:
		$PlayerBoardUI.set_insert_mode()
	
func ai_process_turn_data(data):
	if data["prog"] != null:
		$Hand.remove_prog(data["prog"])
		$PlayerBoardUI.remove_from_hand(data["prog"])
		data["insert_target"].insert_progv(data["prog"], data["insert_point"])
	emit_signal("run_progs", self, data["run"])
	
func insert_progv(prog, insert_point):
	$PlayerBoardUI/Board.insert_progv(prog, insert_point)

func prog_played(_prog):
	if is_human_player:
		$PlayerBoardUI.set_run_mode()

func run_progs(progs):
	$PlayerBoardUI.set_idle_mode()
	emit_signal("run_progs", self, progs)
	
func _on_mulligan():
	for prog in $Hand.hand.duplicate():
		$PlayerBoardUI.remove_from_hand(prog)
		$Hand.remove_prog(prog)
		$Heap.add_to_heap(prog)
	$PlayerBoardUI.set_idle_mode()
	emit_signal("run_progs", self, [])
	
func set_ui_visibility(val):
	$PlayerBoardUI.visible = val
	
func set_matrix_visibility(val):
	$PlayerBoardUI/Board.visible = val

func damage():
	health = health - 1
	$PlayerBoardUI.set_health_val(health)
	if health == 0:
		emit_signal("player_died", self)
		
func get_matrix():
	return $Matrix
