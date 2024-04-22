# Line follower

extends Path2D

var speed : int = 120

func _process(delta : float) -> void:
	$PathFollow2D.progress += delta * speed
