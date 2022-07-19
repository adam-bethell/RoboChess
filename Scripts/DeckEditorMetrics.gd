extends TileMap

var count_mv = 0
var count_at = 0
var count_db = 0
var count_sp = 0
var count_total = 0

func set_deck(deck):
	count_mv = 0
	count_at = 0
	count_db = 0
	count_sp = 0
	count_total = 0	
	
	for card_name in deck:
		var card_count = deck[card_name]
		var type = CardData.card_data[card_name].type
		
		count_total += card_count
		if type == CardData.Type.MOVE:
			count_mv += card_count
		elif type == CardData.Type.ATTACK:
			count_at += card_count
		elif type == CardData.Type.DEBUFF:
			count_db += card_count
		elif type == CardData.Type.SPECIAL:
			count_sp += card_count
			
	var text = _val_to_string(count_mv)
	set_cell(13,1,get_tileset().find_tile_by_name(text[1]))
	set_cell(14,1,get_tileset().find_tile_by_name(text[2]))
	
	text = _val_to_string(count_at)
	set_cell(16,1,get_tileset().find_tile_by_name(text[1]))
	set_cell(17,1,get_tileset().find_tile_by_name(text[2]))
	
	text = _val_to_string(count_db)
	set_cell(19,1,get_tileset().find_tile_by_name(text[1]))
	set_cell(20,1,get_tileset().find_tile_by_name(text[2]))
	
	text = _val_to_string(count_sp)
	set_cell(22,1,get_tileset().find_tile_by_name(text[1]))
	set_cell(23,1,get_tileset().find_tile_by_name(text[2]))
	
	text = _val_to_string(count_total)
	set_cell(27,1,get_tileset().find_tile_by_name(text[0]))
	set_cell(28,1,get_tileset().find_tile_by_name(text[1]))
	set_cell(29,1,get_tileset().find_tile_by_name(text[2]))
	
	if count_mv > 99 || count_at > 99 || count_db > 99 || count_sp > 99:
		return false
	return true
			
func _val_to_string(val):
	var text = String(val)
	if text.length() < 3:
		for _i in range(3 - text.length()):
			text = "0" + text
	return text
