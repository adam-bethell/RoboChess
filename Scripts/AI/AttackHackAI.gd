extends "res://Scripts/AI/UnitAI.gd"

func calculate_turn():
	var options = calculate_options()
	
	var scores = []
	var highest_score = -9999
	
	for option in options:
		var score = 0
		score += (option["damage_given"] * 100)
		score += (option["movement_towards_human"])
		
		if option["prog"] != null:
			if option["prog"].type == CardData.Type.DEBUFF:
				if option["insert_target"] == human_player:
					score += 100
				else:
					score += -200
			else:
				if option["insert_target"] == human_player:
					score += -100
			
		scores.push_back({
			"option": option,
			"score": score,
		})
		if score > highest_score:
			highest_score = score
	
	scores.shuffle()
	for score in scores:
		if score["score"] == highest_score:
			return score["option"]
		
