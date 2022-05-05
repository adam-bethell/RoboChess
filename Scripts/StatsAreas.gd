extends TileMap

func _ready():
	$DeckArea.connect("mouse_entered", self, "_deck_mouse_entered")
	$DeckArea.connect("mouse_exited", self, "_deck_mouse_exited")
	$HeapArea.connect("mouse_entered", self, "_heap_mouse_entered")
	$HeapArea.connect("mouse_exited", self, "_heap_mouse_exited")
	$HealthArea.connect("mouse_entered", self, "_health_mouse_entered")
	$HealthArea.connect("mouse_exited", self, "_health_mouse_exited")

func _deck_mouse_entered():
	Globals.emit_signal("info_bus", self, "Deck: once empty take 1 hit then shuffle in heap")
func _deck_mouse_exited():
	Globals.emit_signal("info_bus", self, null)
	
func _heap_mouse_entered():
	Globals.emit_signal("info_bus", self, "Heap: the discard pile")
func _heap_mouse_exited():
	Globals.emit_signal("info_bus", self, null)
	
func _health_mouse_entered():
	Globals.emit_signal("info_bus", self, "Health: how many more hits you can take")
func _health_mouse_exited():
	Globals.emit_signal("info_bus", self, null)
