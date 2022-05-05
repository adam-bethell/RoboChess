extends Node

signal size_updated

var heap = []

func get_size():
	return heap.size()

func add_to_heap(prog):
	heap.push_back(prog)
	emit_signal("size_updated", heap.size())

func take_progs():
	var progs = []
	while heap.size() > 0:
		progs.push_back(heap.pop_back())
	emit_signal("size_updated", heap.size())
	return progs
