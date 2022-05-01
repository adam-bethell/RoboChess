extends Node

signal size_updated

var heap = []

func get_size():
	return heap.size()

func add_to_heap(prog):
	heap.push_back(prog)
	emit_signal("size_updated", heap.size())

func take_top_prog():
	var prog = heap.pop_front()
	emit_signal("size_updated", heap.size())
	return prog
