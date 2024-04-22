extends Path2D

var speed = 120

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PathFollow2D.progress += delta * speed
