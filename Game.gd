extends Spatial

var _isSoul = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("duality")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		_isSoul = !_isSoul;
		get_tree().call_group("duality", "toggle")

