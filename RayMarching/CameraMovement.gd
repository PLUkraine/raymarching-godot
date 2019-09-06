extends Node

export(float) var MOUSE_SENSITIVITY = 0.05
export(float) var MAX_VELOCITY = 7
var velocity = Vector3()
var mouseOffsets = Vector2()

func compute_direction(pitchRad, yawRad):
    return Vector3(
        cos(pitchRad) * cos(yawRad),
        sin(pitchRad),
        cos(pitchRad) * sin(yawRad)
    )

func _ready():
    # by default we want to lock the mouse cursor
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        mouseOffsets += event.relative * MOUSE_SENSITIVITY
        mouseOffsets.y = clamp(mouseOffsets.y, -89.0, 89.0)
        var newDirection = compute_direction(
            deg2rad(-mouseOffsets.y),
            deg2rad(mouseOffsets.x)
        )
        
        var colorRect = get_parent()
        colorRect.material.set_shader_param("front", newDirection)

func process_input(delta):
    # process movement
    var deltaStep = MAX_VELOCITY * delta
    if Input.is_action_pressed("camera_left"):
        velocity.x = -deltaStep
    elif Input.is_action_pressed("camera_right"):
        velocity.x = deltaStep
    else:
        velocity.x = 0
    
    if Input.is_action_pressed("camera_forward"):
        velocity.z = deltaStep
    elif Input.is_action_pressed("camera_backward"):
        velocity.z = -deltaStep
    else:
        velocity.z = 0
        
    if Input.is_action_pressed("camera_up"):
        velocity.y = deltaStep
    elif Input.is_action_pressed("camera_down"):
        velocity.y = -deltaStep
    else:
        velocity.y = 0
        
    # lock/unlock mouse cursor
    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
    process_input(delta)
    var colorRect = get_parent()
    var pos = colorRect.material.get_shader_param("cameraPos")
    pos += velocity * delta
    colorRect.material.set_shader_param("cameraPos", pos)
