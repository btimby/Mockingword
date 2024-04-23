# A group of platforms, represents a phrase.

# Example usage
#self.platforms = Platforms.New(
#	self.phrase,
#	self.screen_size,
#	Vector2(0, self.screen_size.y - 10)
#)
#self.add_child(self.platforms)

class_name Platforms

extends Node2D

const PlatformsScene := preload("res://platforms.tscn")

var phrase : String
var screen_size : Vector2
var width : int
var platforms : Array
var scroll_targets : Array[Vector2]
var scroll_target : int = 0

@export var scroll_speed : float = 110.0

static func New(phrase : String, size : Vector2, position) -> Platforms:
	var new = PlatformsScene.instantiate()
	new.phrase = phrase
	new.screen_size = size
	new.position = position
	return new

func _ready() -> void:
	var count := len(phrase)
	self.width = (count * 60) + ((count -1) * 10)
	var start : float = ((self.screen_size.x - self.width) / 2) - 10
	if self.width > self.screen_size.x:
		self.scroll_targets = [
			Vector2(1 - (self.width / 2), self.screen_size.y - 10),
			Vector2(self.width / 2, self.screen_size.y - 10),
		]
	for i in range(count):
		if phrase[i] == " ":
			continue
		var platform = Platform.New(start + (i * 80), 0, phrase[i])
		self.add_platform(platform)

func add_platform(p) -> void:
	self.platforms.append(p)
	self.add_child(p)

func get_letters() -> Array[String]:
	var letters = Array()
	for platform in self.platforms:
		var letter = platform.get_letter()
		letters.append(letter)
	return letters

func _physics_process(delta : float) -> void:
	if not self.scroll_targets:
		return
	var target := self.scroll_targets[self.scroll_target]
	if self.position.distance_to(target) < 10.0:
		self.scroll_target += 1
		if self.scroll_target == len(self.scroll_targets):
			self.scroll_target = 0
		target = self.scroll_targets[self.scroll_target]
	self.position = self.position.move_toward(target, delta * self.scroll_speed)
