extends Node

var sprites = {}

func _ready():
	for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
		self.sprites[c] = load("res://images/letters/%s.png" % c)
