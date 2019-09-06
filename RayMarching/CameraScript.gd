extends Node

export(float) var MAX_VELOCITY = 7
var velocity = Vector3()


func process_input(delta):
    var deltaStep = MAX_VELOCITY * delta
    if Input.is_action_pressed("ui_left"):
        velocity.x = -deltaStep
    elif Input.is_action_pressed("ui_right"):
        velocity.x = deltaStep
    else:
        velocity.x = 0
    
    if Input.is_action_pressed("ui_down"):
        velocity.z = deltaStep
    elif Input.is_action_pressed("ui_up"):
        velocity.z = -deltaStep
    else:
        velocity.z = 0
        
    if Input.is_action_pressed("ui_page_up"):
        velocity.y = deltaStep
    elif Input.is_action_pressed("ui_page_down"):
        velocity.y = -deltaStep
    else:
        velocity.y = 0


func _physics_process(delta):
    process_input(delta)
    var colorRect = get_parent()
    var pos = colorRect.material.get_shader_param("cameraPos")
    pos += velocity * delta
    colorRect.material.set_shader_param("cameraPos", pos)
