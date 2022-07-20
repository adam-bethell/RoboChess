extends Node2D

var deck = {}

func _ready():
	deck = Globals.player_deck
	
	$Metrics.set_deck(deck)
	$Cards.set_deck(deck)
	$Cards.connect("card_count_updated", self, "_on_card_count_updated")

func _on_card_count_updated (card_data, count):
	var original_count = 0
	if deck.has(card_data["name"]):
		original_count = deck[card_data["name"]]
	
	if count == 0:
		deck.erase(card_data["name"])
	else:
		deck[card_data["name"]] = count
		
	var result = $Metrics.set_deck(deck)
	if not result:
		deck[card_data["name"]] = original_count
		$Metrics.set_deck(deck)
		$Cards.set_deck(deck)
		
	Globals.player_deck = deck
	
func _process(_delta):
	if Input.is_action_just_pressed("debug_menu"):
		get_tree().change_scene("res://_GameController.tscn")
