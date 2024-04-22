# Captures letters.

class_name Platform

extends StaticBody2D

const PlatformScene := preload("res://platform.tscn")

@onready var letter_sprite : Sprite2D = get_node("LetterSprite")

var expected : String
var _letter : String
var letter : String:
	get = get_letter, set = set_letter

static func New(x : int, y : int, char : String) -> Platform:
	var new = PlatformScene.instantiate()
	new.position.x = x
	new.position.y = y
	new.expected = char
	return new

func capture(letter : Letter) -> void:
	self.letter = letter.letter
	letter.queue_free()

func set_letter(val : String) -> void:
	self._letter = val
	self.letter_sprite.texture = LetterSprites.sprites[val]

func get_letter() -> String:
	return self._letter
