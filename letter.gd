# Letter, a core gameplay element

class_name Letter

extends RigidBody2D

const LetterScene := preload("res://letter.tscn")

@onready var sprite : Sprite2D = get_node("Sprite2D")

var _letter : String
var letter : String :
	get = get_letter, set = set_letter

@export var tumble_speed : float = 0.02

static func New(letter : String, position : Vector2, linear_velocity : Vector2) -> Letter:
	var new := LetterScene.instantiate()
	new.position = position
	new.linear_velocity = linear_velocity
	new._letter = letter
	return new

func get_letter() -> String:
	return _letter

func set_letter(val : String) -> void:
	_letter = val
	self.sprite.texture = LetterSprites.sprites[self._letter]

func _ready()  -> void:
	self.letter = self._letter

func _physics_process(delta : float) -> void:
	if abs(self.linear_velocity.x) > 1:
		self.rotation += delta * self.linear_velocity.x * tumble_speed
	var coll = self.move_and_collide(self.linear_velocity * delta)
	if coll:
		var obj = coll.get_collider()
		if obj.has_method("capture"):
			obj.capture(self)
			return
		self.linear_velocity = self.linear_velocity.bounce(coll.get_normal())

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Exited screen")
	self.queue_free()
