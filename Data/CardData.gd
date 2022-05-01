extends Node

enum Type {MOVE, ATTACK, DEBUFF}
enum Direction {NORTH, SOUTH, EAST, WEST, ALL}
enum Debuff {NOP, STP, DMG}

var card_data = {
	"Move North": {
		"tiles": ["Move North", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.NORTH,
		"distance": 1,
		"debuff": null
	},
	"Move South": {
		"tiles": ["Move South", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.SOUTH,
		"distance": 1,
		"debuff": null
	},
	"Move East": {
		"tiles": ["Move East", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.EAST,
		"distance": 1,
		"debuff": null
	},
	"Move West": {
		"tiles": ["Move West", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.WEST,
		"distance": 1,
		"debuff": null
	},
	"Attack North 1": {
		"tiles": ["Attack North", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.NORTH,
		"distance": 1,
		"debuff": null
	},
	"Attack North 2": {
		"tiles": ["Attack North", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.NORTH,
		"distance": 2,
		"debuff": null
	},
	"Attack South 1": {
		"tiles": ["Attack South", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.SOUTH,
		"distance": 1,
		"debuff": null
	},
	"Attack South 2": {
		"tiles": ["Attack South", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.SOUTH,
		"distance": 2,
		"debuff": null
	},
	"Attack East 1": {
		"tiles": ["Attack East", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.EAST,
		"distance": 1,
		"debuff": null
	},
	"Attack East 2": {
		"tiles": ["Attack East", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.EAST,
		"distance": 2,
		"debuff": null
	},
	"Attack West 1": {
		"tiles": ["Attack West", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.WEST,
		"distance": 1,
		"debuff": null
	},
	"Attack West 2": {
		"tiles": ["Attack West", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.WEST,
		"distance": 2,
		"debuff": null
	},
	"Attack All 1": {
		"tiles": ["Attack All", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.ALL,
		"distance": 1,
		"debuff": null
	},
	"NOP": {
		"tiles": ["Debuff NOP 1", "Debuff NOP 2", "Debuff ID 1", "Debuff ID 2"],
		"type": Type.DEBUFF,
		"direction": null,
		"distance": null,
		"debuff": null,
	}
}
