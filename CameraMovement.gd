extends Node

# expose variables to the editor (and other scripts)
export(float) var MOUSE_SENSITIVITY = 0.05
export(float) var MAX_SPEED = 300

# private variables
var velocity: Vector3 = Vector3()
var mouse_offsets: Vector2 = Vector2() # in degrees


func compute_direction(pitch_rad, yaw_rad):
    """
    Get front unit vector from the pitch and yaw angles
    """
    return Vector3(
        cos(pitch_rad) * cos(yaw_rad),
        sin(pitch_rad),
        cos(pitch_rad) * sin(yaw_rad)
    )


func compute_direction_forward(yaw_rad):
    """
    Get front unit direction on the XZ plane (do not cosidering the height)
    """
    return Vector3(
        cos(yaw_rad),
        0,
        sin(yaw_rad)
    )


func compute_direction_right(yaw_rad):
    """
    Get right unit direction on the XZ plane (do not cosidering the height)
    """
    return Vector3(
        -sin(yaw_rad),
        0,
        cos(yaw_rad)
    )


func update_velocity(delta):
    """
    Update velocity vector using actions (keyboard or gamepad axis)
    """
    # get current step size
    var delta_step = MAX_SPEED * delta
    var direction_forward = compute_direction_forward(deg2rad(mouse_offsets.x))
    var direction_right = compute_direction_right(deg2rad(mouse_offsets.x))
    # we will have no intertion
    # if we release buttons, we will stop immediately
    self.velocity = Vector3()

    # go forward/backward
    if Input.is_action_pressed("camera_forward"):
        self.velocity += delta_step * direction_forward
    elif Input.is_action_pressed("camera_backward"):
        self.velocity -= delta_step * direction_forward

    # strafe left/right
    if Input.is_action_pressed("camera_left"):
        self.velocity -= delta_step * direction_right
    elif Input.is_action_pressed("camera_right"):
        self.velocity += delta_step * direction_right

    # fly up/down
    if Input.is_action_pressed("camera_up"):
        self.velocity.y = delta_step
    elif Input.is_action_pressed("camera_down"):
        self.velocity.y = -delta_step


func update_camera_position(delta):
    """
    Update camera position and pass it to the shader
    """
    var color_rect = get_parent()
    var cur_pos = color_rect.material.get_shader_param("cameraPos")
    var new_pos = cur_pos + self.velocity * delta
    color_rect.material.set_shader_param("cameraPos", new_pos)


func _ready():
    # we want to capture the mouse cursor at the start of the app
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)    


func _input(event):
    """
    Update pitch and yaw angles
    Update the front vector in the shader
    Capture/Release the mouse
    """
    # update the pitch and yaw angles
    # intercept the mouse motion event and ignore all the others
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        mouse_offsets += event.relative * MOUSE_SENSITIVITY
        # keep pitch in (-90, 90) degrees range to prevent reversing the camera
        mouse_offsets.y = clamp(mouse_offsets.y, -87.0, 87.0)
        var new_direction = compute_direction(
            deg2rad(-mouse_offsets.y),
            deg2rad(mouse_offsets.x)
        )
        
        # update front vector in the shader
        var color_rect = get_parent()
        color_rect.material.set_shader_param("front", new_direction)
    
    # capture/release mouse cursor on the 'Escape' button
    if event.is_action_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
    """
    Move the camera with the steady 60 FPS loopback
    """
    update_velocity(delta)
    update_camera_position(delta)
