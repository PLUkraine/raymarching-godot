extends Node

export(float) var MOUSE_SENSITIVITY = 0.05
export(float) var MAX_VELOCITY = 300

var velocity: Vector3 = Vector3()
var mouseOffsets: Vector2 = Vector2()


func compute_direction(pitchRad, yawRad):
	return Vector3(
		cos(pitchRad) * cos(yawRad),
		sin(pitchRad),
		cos(pitchRad) * sin(yawRad)
	).normalized()


func compute_direction_forward(yawRad) -> Vector3:
	return Vector3(
		cos(yawRad),
		0,
		sin(yawRad)
	)
	

func compute_direction_right(yawRad) -> Vector3:
	return Vector3(
		-sin(yawRad),
		0,
		cos(yawRad)
	)
 
   
func update_velocity(delta):
	var deltaStep = MAX_VELOCITY * delta
	var directionForward = compute_direction_forward(deg2rad(mouseOffsets.x))
	var directionRight = compute_direction_right(deg2rad(mouseOffsets.x))
	self.velocity = Vector3()
	
	if Input.is_action_pressed("camera_left"):
		self.velocity -= deltaStep * directionRight
	elif Input.is_action_pressed("camera_right"):
		self.velocity += deltaStep * directionRight
	
	if Input.is_action_pressed("camera_forward"):
		self.velocity += deltaStep * directionForward
	elif Input.is_action_pressed("camera_backward"):
		self.velocity -= deltaStep * directionForward
		
	if Input.is_action_pressed("camera_up"):
		self.velocity.y = deltaStep
	elif Input.is_action_pressed("camera_down"):
		self.velocity.y = -deltaStep


func update_camera_position(delta):
	var colorRect = get_parent()
	var curPos = colorRect.material.get_shader_param("cameraPos")
	var newPos = curPos + self.velocity * delta
	colorRect.material.set_shader_param("cameraPos", newPos)


func _ready():
	# we want to lock the mouse cursor at the start of the app
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	# update camera's front vector
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouseOffsets += event.relative * MOUSE_SENSITIVITY
		# keep pitch in (-90, 90) degrees range to prevent reversing the camera
		mouseOffsets.y = clamp(mouseOffsets.y, -87.0, 87.0)
		var newDirection = compute_direction(
			deg2rad(-mouseOffsets.y),
			deg2rad(mouseOffsets.x)
		)

		var colorRect = get_parent()
		colorRect.material.set_shader_param("front", newDirection)
	
	# lock/unlock mouse cursor
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	update_velocity(delta)
	update_camera_position(delta)
