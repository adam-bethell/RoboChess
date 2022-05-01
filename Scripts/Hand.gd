extends Node

signal prog_added
signal prog_removed

var hand = []

func get_limit():
	return 3

func get_size():
	return hand.size()

func add_prog(prog):
	if prog == null:
		return
	hand.push_back(prog)
	emit_signal("prog_added", prog)

func remove_prog(prog):
	hand.erase(prog)
	emit_signal("prog_removed")
