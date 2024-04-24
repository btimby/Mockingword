# Captures letters.

class_name Platform

extends StaticBody2D

const PlatformScene := preload("res://platform.tscn")

@export var expected : String             # The goal for this platform

@onready var letter_sprite : Sprite2D = get_node("LetterSprite")

var _letter : String                      # Current letter shadow value
var letter : String:                      # Current letter
	get = get_letter, set = set_letter
var disabled : bool = false               # Ignore letters

signal letter_completed                   # Raised when the expected letter is
										  # captured

static func New(x : int, y : int, char : String) -> Platform:
	var new = PlatformScene.instantiate()
	new.position.x = x
	new.position.y = y
	new.expected = char
	return new

func capture(letter : Letter) -> void:
	letter.queue_free()
	if self.disabled:
		# NOTE: if this platform is disabled, it ignores letters.
		return
	print("Captured")
	self.letter = letter.letter
	if check_complete():
		self.confetti()
		self.letter_completed.emit()

func confetti() -> void:
	print("Confetti")
	var confetti = Confetti.New(self.position)
	get_parent().add_child(confetti)

func check_complete():
	return self.letter == self.expected

func release():
	self._letter = ''
	self.letter_sprite.texture = null

func set_letter(val : String) -> void:
	self._letter = val
	self.letter_sprite.texture = LetterSprites.sprites[val]

func get_letter() -> String:
	return self._letter
