extends Node

# expose variables to the editor (and other scripts)
export(float) var MOUSE_SENSITIVITY = 0.05

# private variables
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
