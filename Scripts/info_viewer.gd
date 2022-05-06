extends TileMap

var current_info_owner = null

func _ready():
	Globals.connect("info_bus", self, "display_info")

func display_info (info_owner, info_text):
	if info_text == null && info_owner == current_info_owner:
		clear()
		set_cell(0, 0, get_tileset().find_tile_by_name("info"))
		current_info_owner = null
	elif info_text != null:
		info_text = info_text.to_upper()
		clear()
		set_cell(0, 0, get_tileset().find_tile_by_name("info"))
		current_info_owner = info_owner
		
		var cell = Vector2(1, 0)
		for word in info_text.split(" ", false):
			var space_remaining = 19 - cell.x
			if word.length() > space_remaining:
				cell.x = 1
				cell.y += 1
			
			for character in word:
				set_cellv(cell, get_tileset().find_tile_by_name(character))
				cell += Vector2(1, 0)
				if cell.x >= 19:
					cell.x = 1
					cell.y += 1
			
			cell += Vector2(1, 0)
			if cell.x >= 19:
				cell.x = 1
				cell.y += 1
