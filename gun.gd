class_name Gun

extends Node2D

const GunScene := preload("res://gun.tscn")

@onready var muzzle : Marker2D = get_node("Muzzle")
@onready var line : Line2D #= get_node("Line2D")

@export var aim_min_speed : float = 1.0
@export var aim_max_speed : float = 4.0
@export var aim_accel : float = 0.1
@export var bullet_speed : int = 400
@export var reload_time : float = 1.0
@export var trajectory_points : int = 10

var reloading : bool = false
var aim_speed : float = 0
var gravity : int

static func New(position) -> Gun:
	var new = GunScene.instantiate()
	new.position = position
	return new

func _ready():
	self.gravity = PhysicsServer2D.area_get_param(
			get_viewport().find_world_2d().space,
			PhysicsServer2D.AREA_PARAM_GRAVITY
		)
	self.line = Line2D.new()
	get_parent().add_child(self.line)
	self.line.width = 2
	self.line.modulate = Color.RED

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		self.aim_speed += self.aim_min_speed * self.aim_accel
	elif Input.is_action_pressed("ui_right"):
		self.aim_speed += -self.aim_min_speed * self.aim_accel
	else:
		self.aim_speed = 0

	if self.aim_speed > 0 and self.rotation < 1.3:
		self.rotation += self.aim_speed * delta
	elif self.aim_speed < 0 and self.rotation > -1.3:
		self.rotation += self.aim_speed * delta

func _physics_process(delta):
	self._draw_trajectory(delta)

func _draw_trajectory(delta : float):
	var pos := self.muzzle.global_position
	# NOTE: No idea why I have to divide speed by 4 below!
	var velocity := Vector2(0, self.bullet_speed / 5).rotated(self.rotation)
	self.line.clear_points()
	for i in range(self.trajectory_points):
		self.line.add_point(pos, i)
		velocity.y += (self.gravity * delta)
		pos += velocity

func shoot(letter):
	if self.reloading:
		return
	var projectile := Letter.New(
		letter,
		self.muzzle.global_position,
		Vector2(0, self.bullet_speed).rotated(self.rotation)
	)
	get_parent().add_child(projectile)
	self.reloading = true
	await get_tree().create_timer(self.reload_time).timeout
	self.reloading = false
