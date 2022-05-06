extends Node2D

# Signal used by child classes
# warning-ignore:unused_signal
signal turn_calculated

var map = null
var turn_order = null
var hand = null
var matrix = null
var player = null
var human_player = null

var test_player = {}
var test_human_player = {}

var calculations_complete = false
var options = []
var ran_options = []

func _ready():
	set_process(false)

func calculate_options():
	# Get all turn options
	options = []
	ran_options = []
	options_get()
	option_remove_duplicates()
	set_process(true)

func _process(_delta):
	options_run(10)
	
func options_get():
	var cards = hand.hand
	if cards.size() == 0:
		cards = [null]
		
	for prog in cards:
		for prog_insert_point in matrix.get_insert_points():
			var test_matrix = matrix.clone()
			var dropped_prog = null
			if prog != null:
				dropped_prog = test_matrix.insert_prog(prog, prog_insert_point)
			var prog_count_by_type = test_matrix.get_prog_count_by_type()
			
			for run_insert_point in matrix.get_insert_points():
				var option = {
					"prog": prog,
					"insert_target": player,
					"insert_point": prog_insert_point,
					"run": test_matrix.get_run(run_insert_point),
					"dropped_prog": dropped_prog,
					"prog_count_by_type": prog_count_by_type,
					"movement_towards_human": 0,
					"damage_taken": 0,
					"damage_given": 0,
				}
				options.push_back(option)
			
			test_matrix.queue_free()
			
		for prog_insert_point in human_player.get_matrix().get_insert_points():
			var test_matrix = human_player.get_matrix().clone()
			var dropped_prog = null
			if prog != null:
				dropped_prog = test_matrix.insert_prog(prog, prog_insert_point)
			var prog_count_by_type = matrix.get_prog_count_by_type()
		
			for run_insert_point in matrix.get_insert_points():
				var option = {
					"prog": prog,
					"insert_target": human_player,
					"insert_point": prog_insert_point,
					"run": matrix.get_run(run_insert_point),
					"dropped_prog": dropped_prog,
					"prog_count_by_type": prog_count_by_type,
					"movement_towards_human": 0,
					"damage_taken": 0,
					"damage_given": 0,
				}
				options.push_back(option)
				
			test_matrix.queue_free()
	
	return options

func option_remove_duplicates():
	var updated_options = []
	updated_options.push_back(options.pop_front())
	
	for option in options:
		var collision_found = false
		var option_hash = option.hash()
		for unique_option in updated_options:
			if unique_option.hash() == option_hash:
				collision_found = true
				break
		if not collision_found:
			updated_options.push_back(option)
	
	options = updated_options
			
	
func options_run(count):
	var start_distance_from_human = map.get_distance(player.map_position, human_player.map_position)
	
	for _i in range(count):
		var option = options.pop_front()
		if option == null:
			options = ran_options
			calculations_complete = true
			return
			
		var test_map = map.duplicate(4)
		test_map.connect("player_hit", self, "test_map_hit_player")
		setup_test_players()
		test_map.run_progs(test_player, option["run"], true)
		
		var distance = test_map.get_distance(test_player.map_position, test_human_player.map_position)
		option["movement_towards_human"] = start_distance_from_human - distance
		option["damage_taken"] = player.health - test_player.health
		option["damage_given"] = human_player.health - test_human_player.health
		ran_options.push_back(option)
		test_map.queue_free()

func setup_test_players():
	test_player.map_position = player.map_position
	test_player.health = player.health
	test_human_player.map_position = human_player.map_position
	test_human_player.health = human_player.health
		
func test_map_hit_player(hit_pos):
	assert(test_human_player.has("map_position") && test_human_player.has("health"))
	if test_human_player.map_position == hit_pos:
		test_human_player.health = test_human_player.health - 1
