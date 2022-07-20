extends Control

signal load_level

func _ready():
	$ItemList.connect("item_activated", self, "load_level")
	
	for level_data in CampaignData.levels:
		$ItemList.add_item(level_data["name"])
	$ItemList.add_item("Deck Editor")

func load_level(index):
	if index < CampaignData.levels.size():
		emit_signal("load_level", index)
	
	if $ItemList.get_item_text(index) == "Deck Editor":
		get_tree().change_scene("res://DeckEditor.tscn")
