extends VSlider

export(NodePath) var colorRect

func _ready():
    get_node(colorRect).material.set_shader_param("fov", self.value)
    self.connect("value_changed", self, "_on_value_changed")
    
func _on_value_changed(newValue):
    get_node(colorRect).material.set_shader_param("fov", newValue)
