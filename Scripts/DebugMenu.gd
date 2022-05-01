extends Control

signal load_level

func _ready():
	$ItemList.connect("item_activated", self, "load_level")
	for level_data in LevelData.levels:
		$ItemList.add_item(level_data["name"])

func load_level(index):
	emit_signal("load_level", index)
