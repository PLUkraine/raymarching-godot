extends ColorRect

onready var start_time = OS.get_ticks_msec()

signal fov_changed(value)


func set_fov(value):
	print("Fov: ", value)
	if self.material.get_shader_param("fov") != value:
		self.material.set_shader_param("fov", value)
		emit_signal("fov_changed", value)

	
func _process(delta):
	var time = (OS.get_ticks_msec() - start_time) / 1000.0
	self.material.set_shader_param("lightPos",
		Vector3(2.0*cos(time), 5.0, 2.0*sin(time)))
