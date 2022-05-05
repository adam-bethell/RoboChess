extends Node

func is_unit_tile(tile_name):
	for unit in unit_data:
		if unit["tile_name"] == tile_name:
			return true
	return false
	
func find_unit_data_from_tile_name(tile_name):
	for unit in unit_data:
		if unit["tile_name"] == tile_name:
			return unit
	return null

var unit_data = [
	{
		"name": "You: High Eccleciarch",
		"tile_name": "Player Player",
		"attack_tile": "Melee",
	},
	{
		"name": "Tempestuous Chicken",
		"tile_name": "Player Chicken",
		"health": 1,
		"deck": [
			"Move North", 8,
			"Move South", 8,
			"Move East", 8,
			"Move West", 8
		],
		"matrix_width": 2,
		"matrix_height": 2,
		"ai": "res://Scripts/AI/FleeAI.gd",
		"attack_tile": "Basic Melee",
	},
	{
		"name": "Colossal Insect",
		"tile_name": "Player Bug",
		"health": 1,
		"deck": [
			"Move North", 8,
			"Move South", 8,
			"Move East", 8,
			"Move West", 8,
			"Attack North 1", 3,
			"Attack South 1", 3,
			"Attack East 1", 3,
			"Attack West 1", 3,
		],
		"matrix_width": 2,
		"matrix_height": 2,
		"ai": "res://Scripts/AI/AttackAI.gd",
		"attack_tile": "Basic Melee",
	},
	{
		"name": "Wizened Skeleton",
		"tile_name": "Player Skeleton",
		"health": 4,
		"deck": [
			"Move North", 5,
			"Move South", 10,
			"Move East", 7,
			"Move West", 7,
			"Attack All 1", 10,
			"NOP", 10
		],
		"matrix_width": 2,
		"matrix_height": 2,
		"ai": "res://Scripts/AI/AttackHackAI.gd",
		"attack_tile": "Fire",
	},
	{
		"name": "The Dissident Magus",
		"tile_name": "Player Mage",
		"health": 2,
		"deck": [
			"Attack All 2", 10,
			"NOP", 10,
			"STP", 10,
			"DMG", 10,
		],
		"matrix_width": 1,
		"matrix_height": 1,
		"ai": "res://Scripts/AI/AttackHackAI.gd",
		"attack_tile": "Green Fire",
	}
]
