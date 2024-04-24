# Main game scene

class_name Game

extends Node2D

const LEVELS = [
	preload("res://node_2d.tscn"),
]

var won : bool = false
var current_index : int = 0
var current_level : Node2D

func _ready() -> void:
	self._start_level(self.current_index)

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self._finish_game()

func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_select"):
		self.current_level.shoot()

func _start_level(num : int):
	self.current_level = LEVELS[num].instantiate()
	self.add_child(self.current_level)
	self.current_level.achieved_victory.connect(self._advance_level)

func _advance_level() -> void:
	self.current_index += 1
	if self.current_index > len(LEVELS):
		self._finish_game()
	self.current_level.queue_free()
	self._start_level(self.current_index)

func _finish_game() -> void:
	self.current_level.queue_free()
	get_tree().quit()
