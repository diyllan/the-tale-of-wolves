extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.environment.sky_rotation.y += 0.0010
	if self.environment.sky_rotation.y >= 360:
		self.environment.sky_rotation.y = 0
	
