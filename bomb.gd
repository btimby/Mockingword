class_name Bomb

extends RigidBody2D

const BombScene := preload("res://bomb.tscn")
const ExplosionScene := preload("res://explosion.tscn")

@onready var aoi : Area2D = get_node("Area2D")

@export var min_fuse : float = 0.8
@export var max_fuse : float = 1.2

var _timer : Timer

static func New(position):
	var bomb = BombScene.instantiate()
	bomb.position = position
	return bomb

func _ready():
	var fuse : float = randf_range(self.min_fuse, self.max_fuse)
	self._timer = Timer.new()
	self._timer.wait_time = fuse
	self._timer.connect("timeout", self.explode)
	self.add_child(self._timer)
	self._timer.start()

func explode():
	for body in self.aoi.get_overlapping_bodies():
		if body.has_method('release'):
			body.release()
	var explosion = ExplosionScene.instantiate()
	explosion.emitting = true
	get_parent().add_child(explosion)
	explosion.position = position
	self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.explode()
