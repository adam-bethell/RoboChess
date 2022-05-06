extends Node

enum Type {MOVE = 0, ATTACK, DEBUFF, SPECIAL}
enum Direction {NORTH = 0, SOUTH, EAST, WEST, ALL}

var card_data = {
	"Move North": {
		"description": "MOVE 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Move North", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.NORTH,
		"distance": 1,
		"keywords": []
	},
	"Move South": {
		"description": "MOVE 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Move South", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.SOUTH,
		"distance": 1,
		"keywords": []
	},
	"Move East": {
		"description": "MOVE 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Move East", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.EAST,
		"distance": 1,
		"keywords": []
	},
	"Move West": {
		"description": "MOVE 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Move West", "Move Corner", "Move ID 1", "Move ID 2"],
		"type": Type.MOVE,
		"direction": Direction.WEST,
		"distance": 1,
		"keywords": []
	},
	"Attack North 1": {
		"description": "ATTACK 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack North", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.NORTH,
		"distance": 1,
		"keywords": []
	},
	"Attack North 2": {
		"description": "ATTACK 2 SPACES IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack North", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.NORTH,
		"distance": 2,
		"keywords": []
	},
	"Attack South 1": {
		"description": "ATTACK 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack South", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.SOUTH,
		"distance": 1,
		"keywords": []
	},
	"Attack South 2": {
		"description": "ATTACK 2 SPACES IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack South", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.SOUTH,
		"distance": 2,
		"keywords": []
	},
	"Attack East 1": {
		"description": "ATTACK 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack East", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.EAST,
		"distance": 1,
		"keywords": []
	},
	"Attack East 2": {
		"description": "ATTACK 2 SPACES IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack East", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.EAST,
		"distance": 2,
		"keywords": []
	},
	"Attack West 1": {
		"description": "ATTACK 1 SPACE IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack West", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.WEST,
		"distance": 1,
		"keywords": []
	},
	"Attack West 2": {
		"description": "ATTACK 2 SPACES IN THE DIRECTION OF THE ARROW",
		"tiles": ["Attack West", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.WEST,
		"distance": 2,
		"keywords": []
	},
	"Attack All 1": {
		"description": "ATTACK 1 SPACE IN  ALL DIRECTIONS",
		"tiles": ["Attack All", "Attack Distance 1", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.ALL,
		"distance": 1,
		"keywords": []
	},
	"Attack All 2": {
		"description": "ATTACK 2 SPACES IN ALL DIRECTIONS",
		"tiles": ["Attack All", "Attack Distance 2", "Attack ID 1", "Attack ID 2"],
		"type": Type.ATTACK,
		"direction": Direction.ALL,
		"distance": 2,
		"keywords": []
	},
	"NOP": {
		"description": "DOES NOTHING. SAME AS AN EMPTY SPACE",
		"tiles": ["Debuff NOP 1", "Debuff NOP 2", "Debuff ID 1", "Debuff ID 2"],
		"type": Type.DEBUFF,
		"direction": null,
		"distance": null,
		"keywords": []
	},
	"STP": {
		"description": "STOPS ANY CARDS AFTER IT FROM BEING EXECUTED",
		"tiles": ["Debuff STP 1", "Debuff STP 2", "Debuff ID 1", "Debuff ID 2"],
		"type": Type.DEBUFF,
		"direction": null,
		"distance": null,
		"keywords": ["stop"]
	},
	"DMG": {
		"description": "DOES 1 DAMAGE TO THE USER",
		"tiles": ["Debuff DMG 1", "Debuff DMG 2", "Debuff ID 1", "Debuff ID 2"],
		"type": Type.DEBUFF,
		"direction": null,
		"distance": null,
		"keywords": ["dmg"]
	},
	"Rotate CW": {
		"description": "Turns card being pointed to then self clockwise",
		"tiles": ["SP Rotator 1", "SP Rotator CW", "SP Rotator 2", "SP"],
		"type": Type.SPECIAL,
		"direction": null,
		"distance": null,
		"keywords": ["spin cw"]
	},
	"Rotate ACW": {
		"description": "Turns card being pointed to then self anticlockwise",
		"tiles": ["SP Rotator 1", "SP Rotator ACW", "SP Rotator 2", "SP"],
		"type": Type.SPECIAL,
		"direction": null,
		"distance": null,
		"keywords": ["spin acw"]
	}
} 
