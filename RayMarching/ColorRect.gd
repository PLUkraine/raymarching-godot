extends ColorRect

onready var start_time = OS.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_param("cameraPos", Vector3(0, 0, 10.0))
	
func _process(delta):
	var time_since_start = (OS.get_ticks_msec() - start_time) / 1000.0
	
	self.material.set_shader_param("cameraPos", 
		Vector3(0, 0, 5.0 + 2.0 * cos(time_since_start)))
