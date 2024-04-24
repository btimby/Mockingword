# Line follower

extends Path2D

@onready var path_follow : PathFollow2D = get_node("PathFollow2D")

@export var speed : float = 0.1
var direction : int = 1

func _process(delta : float) -> void:
	if self.path_follow.progress_ratio >= 0.95:
		self.direction = -1
	elif self.path_follow.progress_ratio <= 0.05:
		self.direction = 1
	self.path_follow.progress_ratio += delta * self.speed * self.direction
