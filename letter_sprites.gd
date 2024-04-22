# Loader for letter sprites (autoload singleton)

extends Node

var sprites = {}

func _ready() -> void:
	for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
		self.sprites[c] = load("res://images/letters/%s.png" % c)
