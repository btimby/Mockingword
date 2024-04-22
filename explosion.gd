extends CPUParticles2D


func _ready():
	self.connect("finished", self.queue_free)
