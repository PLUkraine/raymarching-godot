extends Node

export(float) var WHEEL_STEP = 4

# onready will execute when the script is starting to run
onready var fov = get_parent().material.get_shader_param("fov")

func update_fov(new_fov):
    # keep FOV in the [15, 135] range
    self.fov = clamp(new_fov, 15, 135)
    get_parent().material.set_shader_param("fov", self.fov)

func _input(event):
    """
    Process the mouse wheel scroll event to change the FOV
    """
    # intercept the mouse wheel up/down event
    if event.is_action_pressed("camera_zoom_in"):
        update_fov(fov - WHEEL_STEP)
    elif event.is_action_pressed("camera_zoom_out"):
        update_fov(fov + WHEEL_STEP)
    