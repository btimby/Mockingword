# Obstacle that converts letter to a random one when touched.

class_name Cipher

extends Obstacle

const WIDTH : int = 41
const HEIGHT : int = 41

@onready var sprite : Sprite2D = get_node("Sprite2D")

var _timer : Timer

@export var redraw : float = 0.05
@export var color : Color = Color(255,0,0,255)
@export var color_threshold : float = 0.5

func _ready() -> void:
	self._timer = Timer.new()
	self._timer.wait_time = self.redraw
	self._timer.connect("timeout", self._redraw)
	self.add_child(self._timer)
	self._timer.start()
	self._redraw()

func _redraw() -> void:
	var noise_gen := FastNoiseLite.new()
	noise_gen.seed = randi()
	var noise := noise_gen.get_image(WIDTH, HEIGHT)
	var image := Image.create(WIDTH, HEIGHT, false, Image.FORMAT_RGBA8)

	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var val : float = float(noise.get_pixel(x, y).to_rgba32()) / 4294967295
			if randf() > 0.75: #self.color_threshold:
				image.set_pixel(x, y, self.color)
			else:
				image.set_pixel(x, y, Color(0, 0, 0, 0))

	var texture := ImageTexture.create_from_image(image)
	self.sprite.texture = texture

func _on_area_2d_body_entered(body : Variant) -> void:
	if "letter" not in body:
		return
	var i : int = randi() % 26
	body.letter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[i]
