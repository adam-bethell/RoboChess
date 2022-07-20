extends Node2D

signal game_over
signal level_complete

var Prog = preload("res://ProgInstruction.tscn")
var Player = preload("res://Player.tscn")

var human_player = null
var enemy_players = []

var current_player = null
var turn_order = []

var is_game_over = false
var is_level_complete = false

func _ready():
	randomize()
	
func setup(level_data, player_deck_data):
	$Map.setup(level_data)
	setup_players(player_deck_data)
	
	$Map.connect("player_clicked", self, "_on_player_clicked")
	$Map.connect("map_clicked", self, "_on_map_clicked")
	$Map.connect("player_hit", self, "_on_player_hit")
	$Map.connect("run_progs_finished", self, "_on_turn_ended")
	
	$Map.connect("highlight_player_pos", self, "_on_player_pos_highlight")
	$TurnOrder.connect("highlight_turn", self, "_on_turn_order_highlight")
	
	setup_turn_order()
	current_player.start_turn()
			

func setup_players(player_deck_data):
	for data in $Map.get_player_map_positions():
		if data[0] == "Player Player":
			human_player = Player.instance()
			add_child(human_player)
			human_player.setup(construct_deck(player_deck_data), 6, data[1], 4, 4, data[0], null)
			human_player.connect("init_run", $Map, "init_run")
			human_player.connect("player_died", $Map, "player_died")
			human_player.connect("player_died", self, "_on_player_died")
			break
			
	for data in $Map.get_player_map_positions():
		if data[0] != "Player Player":
			var unit_data = UnitData.find_unit_data_from_tile_name(data[0])
			var player = Player.instance()
			var ai = load(unit_data["ai"]).new()
			ai.map = $Map
			ai.turn_order = turn_order
			ai.human_player = human_player
			enemy_players.push_back(player)
			add_child(player)
			player.setup(
				construct_deck(unit_data["deck"]), 
				unit_data["health"], 
				data[1], 
				unit_data["matrix_width"], 
				unit_data["matrix_height"],
				data[0],
				ai
			)
			player.connect("init_run", $Map, "init_run")
			player.connect("player_died", $Map, "player_died")
			player.connect("player_died", self, "_on_player_died")

func setup_turn_order():
	turn_order.push_back(human_player)
	for e in enemy_players:
		turn_order.push_back(e)
	
	current_player = turn_order.pop_front()
	$TurnOrder.update_order(current_player, turn_order)

func construct_deck(card_names):
	var deck = []
	for i in range(0, card_names.size(), 2):
		for _j in range(card_names[i+1]):
			var card_data = CardData.card_data[card_names[i]]
			var prog = Prog.instance()
			prog.setup(card_data)
			deck.push_back(prog)
	return deck
	
func _on_player_clicked(map_pos):
	if human_player.map_position == map_pos:
		human_player.set_matrix_visibility(true)
	else:
		human_player.set_matrix_visibility(false)
	
	for e in enemy_players:
		if e.map_position == map_pos:
			e.set_ui_visibility(true)
		else:
			e.set_ui_visibility(false)
			
func _on_map_clicked():
	_on_player_clicked(human_player.map_position)
			
func _on_player_hit(map_pos):
	if human_player.map_position == map_pos:
		human_player.damage()
	else:
		for e in enemy_players:
			if e.map_position == map_pos:
				e.damage()
				
func _on_turn_ended():
	if is_game_over:
		emit_signal("game_over")
	elif is_level_complete:
		emit_signal("level_complete")
	else:
		var previous_player = current_player
		turn_order.push_back(current_player)
		current_player = turn_order.pop_front()
		if previous_player.health <= 0:
			_on_player_died(previous_player)
		current_player.start_turn()
		$TurnOrder.update_order(current_player, turn_order)

func _on_player_died(player):
	if player == human_player:
		is_game_over = true
	elif player != current_player:
		# Dying during your own turn causes all kinds of problems
		# Instead check for death as part of _on_turn_ended()
		enemy_players.erase(player)
		turn_order.erase(player)
		if enemy_players.empty():
			is_level_complete = true
			
func _on_turn_order_highlight(index):
	if index == null:
		$Map.unhighlight_all()
	elif index == -1:
		$Map.highlight(current_player.map_position)
	elif index < turn_order.size():
		$Map.highlight(turn_order[index].map_position)
		
func _on_player_pos_highlight(pos):
	if pos == null:
		$TurnOrder.unhighlight_all()
	elif current_player.map_position == pos:
		$TurnOrder.highlight(-1)
	else:
		for i in range(turn_order.size()):
			var player = turn_order[i]
			if player.map_position == pos:
				$TurnOrder.highlight(i)
