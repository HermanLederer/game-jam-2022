extends Spatial

var _isSoul = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("duality")

var nextSwitch: int = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (OS.get_unix_time() > nextSwitch):
		if (Input.is_action_just_pressed("ui_accept")):
			var m = get_node("/root/Game/Level/Meditation").transform.origin;
			var p = get_node("/root/Game/Player").transform.origin;
			if (p.distance_to(m) < 1.1 || _isSoul):
				nextSwitch = OS.get_unix_time() + 1
				_isSoul = !_isSoul;
				get_tree().call_group("duality", "toggle")

