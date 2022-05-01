extends Node

signal size_updated

var deck = []

func add_prog(prog):
	deck.push_back(prog)
	emit_signal("size_updated", deck.size())

func shuffle():
	deck.shuffle()
	
func draw():
	var prog = deck.pop_front()
	emit_signal("size_updated", deck.size())
	return prog
