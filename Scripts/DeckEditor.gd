extends Node2D

var deck = {}

func _ready():
	$Metrics.set_deck(deck)
	$Cards.set_deck(deck)
	$Cards.connect("card_count_updated", self, "_on_card_count_updated")

func _on_card_count_updated (card_data, count):
	var original_count = 0
	if deck.has(card_data["name"]):
		original_count = card_data["name"]
	
	if count == 0:
		deck.erase(card_data["name"])
	else:
		deck[card_data["name"]] = count
		
	var result = $Metrics.set_deck(deck)
	if not result:
		deck[card_data["name"]] = original_count
		$Metrics.set_deck(deck)
		$Cards.set_deck(deck)
