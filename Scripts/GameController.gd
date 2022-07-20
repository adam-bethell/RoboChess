extends Node2D

var Level = preload("res://LevelController.tscn")
var DebugMenu = preload("res://DebugMenu.tscn")
var debug_menu = null

var current_level = null
var current_level_index = 0

func _ready():
	load_level(current_level_index)
	
func load_level(index):
	current_level_index = index
	
	if current_level != null:
		remove_child(current_level)
		current_level.queue_free()
	if debug_menu != null:
		remove_child(debug_menu)
		debug_menu.queue_free()
		debug_menu = null
	
	if CampaignData.levels[index]["intro_scene"] != "":
		add_child(load(CampaignData.levels[index]["intro_scene"]).instance())
	current_level = Level.instance()
	add_child(current_level)
	var level_data = load(CampaignData.levels[index]["map_data"]).instance()
		
	current_level.setup(level_data, player_deck_to_list())
	
	current_level.connect("game_over", self, "game_over")
	current_level.connect("level_complete", self, "level_complete")
	
func game_over():
	print("game_over")
	
func level_complete():
	current_level_index = current_level_index + 1
	if current_level_index >= CampaignData.levels.size():
		current_level_index = 0
	load_level(current_level_index)
	
func _process(_delta):
	if Input.is_action_just_pressed("debug_menu"):
		if debug_menu == null:
			debug_menu = DebugMenu.instance()
			debug_menu.connect("load_level", self, "load_level")
			add_child(debug_menu)
		else:
			remove_child(debug_menu)
			debug_menu.queue_free()
			debug_menu = null
			
func player_deck_to_list():
	var card_list = []
	for card_name in Globals.player_deck:
		card_list.push_back(card_name)
		card_list.push_back(Globals.player_deck[card_name])
	return card_list
	
