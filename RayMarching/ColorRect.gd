extends ColorRect

onready var start_time = OS.get_ticks_msec()

    
func _process(delta):
    var time = (OS.get_ticks_msec() - start_time) / 1000.0
    self.material.set_shader_param("lightPos",
        Vector3(2.0*cos(time), 5.0, 2.0*sin(time)))
    
#    self.material.set_shader_param("fov", 
#        15.0 * cos(time_since_start) + 45.0)
#    self.material.set_shader_param("cameraPos", 
#        Vector3(2.0 * cos(time_since_start), 0, 5.0))
