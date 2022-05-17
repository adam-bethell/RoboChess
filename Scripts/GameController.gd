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
	
	var card_names = []
	card_names.push_back("Swap NS")
	card_names.push_back(8)
	card_names.push_back("Swap EW")
	card_names.push_back(8)
	card_names.push_back("Rotate CW")
	card_names.push_back(8)
	card_names.push_back("Rotate ACW")
	card_names.push_back(8)
	card_names.push_back("Move North")
	card_names.push_back(8)
	card_names.push_back("Move South")
	card_names.push_back(8)
	card_names.push_back("Move East")
	card_names.push_back(8)
	card_names.push_back("Move West")
	card_names.push_back(8)
	card_names.push_back("Attack North 2")
	card_names.push_back(3)
	card_names.push_back("Attack South 2")
	card_names.push_back(3)
	card_names.push_back("Attack East 2")
	card_names.push_back(3)
	card_names.push_back("Attack West 2")
	card_names.push_back(3)
		
	current_level.setup(level_data, card_names)
	
	current_level.connect("game_over", self, "game_over")
	current_level.connect("level_complete", self, "level_complete")
	
func game_over():
	print("game_over")
	
func level_complete():
	current_level_index = current_level_index + 1
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
		
