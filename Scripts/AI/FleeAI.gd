extends "res://Scripts/AI/UnitAI.gd"

func calculate_turn():
	set_process(true)
	calculate_options()

func _process(_delta):
	if calculations_complete:
		score_options()
		calculations_complete = false
		set_process(false)

func score_options():
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
			emit_signal("turn_calculated", score["option"])
			return
	assert(false)
		
		
	
