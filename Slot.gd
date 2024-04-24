# Queue slot for a letter.

class_name Slot

extends Node2D

const SlotScene := preload("res://slot.tscn")

@onready var sprite : Sprite2D = get_node("Sprite2D")

var choices : Array[String]
var _letter : String
var letter : String :
	get = get_letter, set = set_letter
var number : int
var duration : float

static func New(choices: Array[String], position : Vector2, duration : float) -> Slot:
	var new = SlotScene.instantiate()
	new.choices = choices
	new.position = position
	new.duration = duration
	return new

func _ready() -> void:
	self.pick()

func pick() -> String:
	var i = randi() % len(self.choices)
	self.letter = self.choices[i]
	return self.letter

func set_letter(val : String) -> void:
	_letter = val
	self.sprite.texture = LetterSprites.sprites[val]

func get_letter() -> String:
	return _letter

func slide_left(amount : int) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(
		self,
		"position:x",
		self.position.x - amount,
		self.duration
	)

func fade_out(cb : Callable) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self.sprite, "modulate:a", 0.0, self.duration)
	tween.tween_callback(cb)

func fade_in(alpha : float, start : float = -1.0) -> void:
	if start != -1.0:
		self.sprite.modulate.a = start
	var tween := get_tree().create_tween()
	tween.tween_property(self.sprite, "modulate:a", alpha, self.duration)
