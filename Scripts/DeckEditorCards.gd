extends Node2D

signal card_count_updated

var Prog = preload("res://ProgInstruction.tscn")
var Counter = preload("res://CardCounter.tscn")

var cards = []
var counters = {}

func _ready():
	var x = 0
	var y = 0
	
	for card_name in CardData.card_data:
		var card = CardData.card_data[card_name]
		var prog = Prog.instance()
		add_child(prog)
		cards.push_back(prog)
		prog.setup(card)
		prog.set_spin(CardData.Direction.NORTH)
		var counter = Counter.instance()
		counter.connect("count_updated", self, "_on_card_count_updated")
		prog.add_child(counter)
		counter.card_data = card
		counters[card_name] = counter
		
		prog.transform.origin = coord_to_pos(x, y)
		x += 1
		if x > 10:
			x = 0
			y += 1
		
func set_deck(deck):
	for card_name in deck:
		counters[card_name].set_count(deck[card_name])
		
func coord_to_pos (x, y) -> Vector2:
	return Vector2(x*48,y*48)

func _on_card_count_updated (card_data, count):
	emit_signal("card_count_updated", card_data, count)
