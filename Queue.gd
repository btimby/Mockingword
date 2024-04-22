class_name Queue

extends Node2D

const QueueScene := preload("res://queue.tscn")

var capacity : int
var slots : Array[Slot]
var phrase : String
var letters : Array[String]

static func New(phrase : String, capacity : int, position : Vector2) -> Queue:
	var new := QueueScene.instantiate()
	new.phrase = phrase
	new.capacity = capacity
	new.position = position
	return new

func _ready() -> void:
	for l in self.phrase:
		if l == " ":
			continue
		self.letters.append(l.capitalize())
	for i in range(self.capacity):
		var slot := self.add_slot(
			Slot.New(
				self.letters,
				Vector2(self.position.x + i * 60, self.position.y))
		)
		if i > 0:
			slot.sprite.modulate.a = 0.3

func add_slot(slot : Slot) -> Slot:
	self.slots.append(slot)
	self.get_parent().add_child(slot)
	return slot

func shift() -> String:
	var head = self.slots[0]
	var tail = self.add_slot(
		Slot.New(
			self.letters,
			Vector2(self.position.x + self.capacity * 60, self.position.y))
		)
	for s in self.slots:
		s.slide_left(60)
	self.slots[1].fade_in(1.0)
	head.fade_out(self._pop_head)
	tail.fade_in(0.3, 0.0)
	return head.letter

func _pop_head() -> void:
	var head = self.slots.pop_front()
	head.queue_free()
