extends Node

# warning-ignore:unused_signal
signal info_bus

var grabbed_prog = null
var mouse_follower_overider = null
var mouse_follower_overider_owner = null

var player_deck = {}

func _ready():
	player_deck["Swap NS"] = 3
	player_deck["Swap EW"] = 3
	player_deck["Rotate CW"] = 3
	player_deck["Rotate ACW"] = 3
	player_deck["Move North"] = 8
	player_deck["Move South"] = 8
	player_deck["Move East"] = 8
	player_deck["Move West"] = 8
	player_deck["Attack North 2"] = 8
	player_deck["Attack South 2"] = 8
	player_deck["Attack East 2"] = 8
	player_deck["Attack West 2"] = 8
