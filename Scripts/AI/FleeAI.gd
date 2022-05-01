extends "res://Scripts/AI/UnitAI.gd"

func calculate_turn():
	var options = calculate_options()
	
	var scores = []
	var highest_score = -9999
	
	for option in options:
		if option["insert_target"] != player:
			continue
		var score = 0
		score += (option["movement_towards_human"] * -1)
		
		for prog in option["run"]:
			if prog.type == CardData.Type.ATTACK:
				score += 5
		
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
		
		
	
