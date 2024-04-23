# Level 1
extends Node2D

@onready var screen_size := get_viewport().get_visible_rect().size
@onready var platforms_node : Node = get_node("Platforms")

var phrase := "TRUMP WON"
var queue : Queue
var platforms : Array[Platform]
var _won : bool
var gun : Node2D
var left : StaticBody2D
var right : StaticBody2D

func _ready() -> void:
	self._create_boundaries()
	for p : Platform in self.platforms_node.get_children():
		p.letter_completed.connect(func (): self._on_letter_completed(p))
		self.platforms.append(p)
	self.gun = Gun.New(Vector2(self.screen_size.x / 2, 0))
	self.add_child(self.gun)
	self.queue = Queue.New(
		self.phrase,
		6,
		Vector2(self.screen_size.x / 2 + 100, 30)
	)
	self.add_child(self.queue)

func _on_letter_completed(platform : Platform) -> void:
	for p in self.platforms:
		if p.check_complete():
			continue
		return
	# Player won!
	self._won = true
	var t := Timer.new()
	t.wait_time = 1.0
	t.timeout.connect(self._fire_salvo)
	self.add_child(t)
	t.start()
	self._fire_salvo()
	# TODO: call game scene to count score and advance game.

func _fire_salvo() -> void:
	for p in self.platforms:
		p.confetti()

func _create_sbody() -> StaticBody2D:
	var body := StaticBody2D.new()
	var owner := body.create_shape_owner(body)
	var shape := RectangleShape2D.new()
	shape.size = Vector2(1, self.screen_size.y)
	body.shape_owner_add_shape(owner, shape)
	self.add_child(body)
	return body

func _create_boundaries() -> void:
	self.left = self._create_sbody()
	self.left.position.x = self.screen_size.x
	self.left.position.y = self.screen_size.y / 2
	self.right = self._create_sbody()
	self.right.position.x = 0
	self.right.position.y = self.screen_size.y / 2

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta : float) -> void:
	if Input.is_action_pressed("ui_select"):
		self.shoot()

func shoot() -> void:
	if self.gun.reloading:
		return
	var letter := self.queue.shift()
	self.gun.shoot(letter)
