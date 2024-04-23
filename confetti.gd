class_name Confetti

extends Node2D

const ConfettiScene : PackedScene = preload("res://confetti.tscn")

@onready var green : CPUParticles2D = get_node("Green")
@onready var blue : CPUParticles2D = get_node("Blue")
@onready var white : CPUParticles2D = get_node("White")

var _finished : int = 0

static func New(position : Vector2) -> Confetti:
	var confetti : Confetti = ConfettiScene.instantiate()
	confetti.position = position
	return confetti

func _ready():
	self.green.connect("finished", self.finished)
	self.blue.connect("finished", self.finished)
	self.white.connect("finished", self.finished)
	self.green.emitting = true
	self.blue.emitting = true
	self.white.emitting = true

func finished():
	self._finished += 1
	if self._finished == 3:
		self.queue_free()
