extends VSlider

export(NodePath) var colorRect
export(float) var wheelStep = 4

onready var shaderNode = get_node(colorRect)

func _ready():
	# set current value
	shaderNode.set_fov(self.value)
	# connect signals
	self.connect("value_changed", self, "_on_value_changed")
	shaderNode.connect("fov_changed", self, "on_fov_model_changed")
	

func _input(event):
	# scroll wheel to change fov
	if event.is_action_pressed("camera_zoom_in"):
		value -= wheelStep
	elif event.is_action_pressed("camera_zoom_out"):
		value += wheelStep
	

func on_fov_model_changed(newValue):
	if value != newValue:
		value = newValue
	

func _on_value_changed(newValue):
	shaderNode.set_fov(self.value)
