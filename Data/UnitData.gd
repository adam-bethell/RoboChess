extends Node

var unit_data = {
	"Player Player": {
		"attack_tile": "Melee",
	},
	"Player Chicken": {
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
	"Player Bug": {
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
	"Player Skeleton": {
		"health": 4,
		"deck": [
			"Move North", 8,
			"Move South", 8,
			"Move East", 8,
			"Move West", 8,
			"Attack All 1", 10,
			"NOP", 8,
		],
		"matrix_width": 2,
		"matrix_height": 2,
		"ai": "res://Scripts/AI/AttackHackAI.gd",
		"attack_tile": "Fire",
	}
}
