extends KinematicBody


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_right")): transform.origin.x -= 1;
	if (Input.is_action_just_pressed("ui_left")): transform.origin.x += 1;
	if (Input.is_action_just_pressed("ui_up")): transform.origin.z += 1;
	if (Input.is_action_just_pressed("ui_down")): transform.origin.z -= 1;
