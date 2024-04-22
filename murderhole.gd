# A hole that attacks / impediments are dropped from.

extends Node2D

@export var interval : float = 3.0

var _timer : Timer

func _ready():
	self._timer = Timer.new()
	self._timer.wait_time = self.interval
	self._timer.connect("timeout", self.drop_countermeasure)
	self.add_child(self._timer)
	self._timer.start()

func drop_countermeasure():
	print("Dropping countermeasure")
	var bomb : Bomb = Bomb.New(self.global_position)
	get_parent().get_parent().add_child(bomb)
