extends TileMap

signal prog_played_from_hand

enum {INSERT = 0, RUN = 1, IDLE = 2}

var hand = [null, null, null]
var current_mode = IDLE

var mouse_follower_offset = Vector2.ZERO

var is_human_player = false
var player_tile
onready var matrix_entries = [$MatrixEntry1, $MatrixEntry2, $MatrixEntry3]

func setup (_is_human_player, tile):
	player_tile = tile
	is_human_player = _is_human_player
	if is_human_player:
		$MatrixEntry1.connect("mouse_down", self, "pickup_prog")
		$MatrixEntry2.connect("mouse_down", self, "pickup_prog")
		$MatrixEntry3.connect("mouse_down", self, "pickup_prog")
	$Board.connect("matrix_entry_mouse_entered", self, "matrix_entry_entered")
	$Board.connect("matrix_entry_mouse_exited", self, "matrix_entry_exited")
	$Board.connect("matrix_entry_mouse_down", self, "matrix_entry_click")
	
	if not is_human_player:
		hide_hunan_player_ui()
		current_mode = INSERT
		
	set_deck_count(0)
	set_heap_count(0)
	set_health_val(0)
		
func _process(_delta):
	if Globals.grabbed_prog == null:
		return
	
	if Globals.mouse_follower_overider == null && is_human_player:
		Globals.grabbed_prog.transform.origin = get_local_mouse_position() + mouse_follower_offset
		
	if Input.is_action_just_released("click") && is_human_player:
		if Globals.mouse_follower_overider == null:
			Globals.grabbed_prog.transform.origin = Vector2.ZERO
		else:
			remove_from_hand(Globals.grabbed_prog)
			emit_signal("prog_played_from_hand", Globals.grabbed_prog)
			Globals.mouse_follower_overider_owner.get_node("Board").insert_prog(Globals.grabbed_prog, Globals.mouse_follower_overider)
		
		Globals.grabbed_prog.z_index = 1;
		Globals.grabbed_prog = null
		Globals.mouse_follower_overider = null

func _val_to_string(val):
	var text = String(val)
	if text.length() == 1:
		text = "0" + text
	return text
	
func set_deck_count(val):
	var text = _val_to_string(val)
	$Stats.set_cell(1,0,$Stats.get_tileset().find_tile_by_name("Background Light"))
	$Stats.set_cell(2,0,$Stats.get_tileset().find_tile_by_name("Background Light"))
	yield(get_tree().create_timer(0.2), "timeout")
	$Stats.set_cell(1,0,$Stats.get_tileset().find_tile_by_name(text[0]))
	$Stats.set_cell(2,0,$Stats.get_tileset().find_tile_by_name(text[1]))
	
func set_heap_count(val):
	var text = _val_to_string(val)
	$Stats.set_cell(5,0,$Stats.get_tileset().find_tile_by_name("Background Light"))
	$Stats.set_cell(6,0,$Stats.get_tileset().find_tile_by_name("Background Light"))
	yield(get_tree().create_timer(0.2), "timeout")
	$Stats.set_cell(5,0,$Stats.get_tileset().find_tile_by_name(text[0]))
	$Stats.set_cell(6,0,$Stats.get_tileset().find_tile_by_name(text[1]))
	
func set_health_val(val):
	var text = _val_to_string(val)
	$Stats.set_cell(9,0,$Stats.get_tileset().find_tile_by_name("Melee"))
	$Stats.set_cell(10,0,$Stats.get_tileset().find_tile_by_name("Melee"))
	yield(get_tree().create_timer(0.2), "timeout")
	$Stats.set_cell(9,0,$Stats.get_tileset().find_tile_by_name(text[0]))
	$Stats.set_cell(10,0,$Stats.get_tileset().find_tile_by_name(text[1]))

func set_idle_mode():
	$Mulligan.visible = false
	#$Board.visible = false
	$Board.show_card_slots()
	current_mode = IDLE
	$RunIndicator.visible = false
	
func set_insert_mode():
	$Mulligan.visible = true
	#$Board.visible = true
	$Board.show_card_slots()
	current_mode = INSERT
	$RunIndicator.visible = false

func set_run_mode():
	$Mulligan.visible = false
	$Board.show_run_starts()
	current_mode = RUN
	$RunIndicator.visible = true
	
func add_to_hand(prog):
	for i in range(hand.size()):
		if hand[i] == null:
			hand[i] = prog
			matrix_entries[i].add_child(prog)
			prog.transform.origin = Vector2.ZERO
			break

func remove_from_hand(prog):
	for i in range(hand.size()):
		if hand[i] == prog:
			hand[i] = null
			matrix_entries[i].remove_child(prog)
			break
			
func pickup_prog(matrixEntry):
	if current_mode != INSERT:
		return
	
	if Globals.grabbed_prog != null:
		return
		
	for child in matrixEntry.get_children():
		if child in hand:
			mouse_follower_offset = get_local_mouse_position() * -1
			Globals.grabbed_prog = child
			Globals.grabbed_prog.z_index = 10;
			
func matrix_entry_entered(matrixEntry):
	if current_mode == INSERT:
		if Globals.grabbed_prog == null:
			return
		Globals.mouse_follower_overider = matrixEntry
		Globals.mouse_follower_overider_owner = self
		Globals.grabbed_prog.global_position = matrixEntry.global_position
	elif current_mode == RUN && is_human_player:
		$RunIndicator.visible = true
	$RunIndicator.global_position = matrixEntry.global_position
	
func matrix_entry_exited(matrixEntry):
	if current_mode == INSERT:
		if Globals.grabbed_prog == null:
			return
		if Globals.mouse_follower_overider == matrixEntry:
			Globals.mouse_follower_overider = null
	elif current_mode == RUN && is_human_player:
		if $RunIndicator.global_position == matrixEntry.global_position:
			$RunIndicator.visible = false

func matrix_entry_click(matrixEntry):
	if current_mode != RUN:
		return
	$Board.run(matrixEntry)
		
func hide_hunan_player_ui():
	$MatrixEntry1.visible = false
	$MatrixEntry2.visible = false
	$MatrixEntry3.visible = false
	$Mulligan.visible = false
	clear()
	$PlayerBackground.visible = false
	$NonPlayerBackground.visible = true
	#transform.origin = transform.origin + Vector2(-16, -16)
	$Stats.transform.origin = $Stats.transform.origin + Vector2(0, 80)
	$Stats.set_cell(8,0,$Stats.get_tileset().find_tile_by_name(player_tile))
	z_index = 2
	visible = false
