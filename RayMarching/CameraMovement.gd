extends Node

export(float) var MOUSE_SENSITIVITY = 0.05
export(float) var MAX_VELOCITY = 7
var velocity: Vector3 = Vector3()
var mouseOffsets: Vector2 = Vector2()


func compute_direction(pitchRad, yawRad):
    return Vector3(
        cos(pitchRad) * cos(yawRad),
        sin(pitchRad),
        cos(pitchRad) * sin(yawRad)
    )


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
 
   
func process_input(delta):
    # process movement
    var deltaStep = MAX_VELOCITY * delta
    var directionForward = compute_direction_forward(deg2rad(mouseOffsets.x))
    var directionRight = compute_direction_right(deg2rad(mouseOffsets.x))
    velocity = Vector3()
    
    if Input.is_action_pressed("camera_left"):
        velocity -= deltaStep * directionRight
    elif Input.is_action_pressed("camera_right"):
        velocity += deltaStep * directionRight
    
    if Input.is_action_pressed("camera_forward"):
        velocity += deltaStep * directionForward
    elif Input.is_action_pressed("camera_backward"):
        velocity -= deltaStep * directionForward
        
    if Input.is_action_pressed("camera_up"):
        velocity.y = deltaStep
    elif Input.is_action_pressed("camera_down"):
        velocity.y = -deltaStep
        
    # lock/unlock mouse cursor
    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _ready():
    # by default we want to lock the mouse cursor
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    

func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        mouseOffsets += event.relative * MOUSE_SENSITIVITY
        mouseOffsets.y = clamp(mouseOffsets.y, -75.0, 75.0)
        var newDirection = compute_direction(
            deg2rad(-mouseOffsets.y),
            deg2rad(mouseOffsets.x)
        )

        var colorRect = get_parent()
        colorRect.material.set_shader_param("front", newDirection)


func _physics_process(delta):
    process_input(delta)
    var colorRect = get_parent()
    var pos = colorRect.material.get_shader_param("cameraPos")
    pos += velocity * delta
    colorRect.material.set_shader_param("cameraPos", pos)
