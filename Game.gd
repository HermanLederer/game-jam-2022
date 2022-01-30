extends Spatial

var _isSoul = false;

var nextSwitch: int = 0;

var levels;
var next_lvl = 0;

func a():
	levels = get_node("/root/Game/Levels").get_children();
	for level in levels:
		get_node("/root/Game/Levels").remove_child(level);

func next_level():
	var l = get_node("/root/Game/Levels").get_children();
	for level in l:
		get_node("/root/Game/Levels").remove_child(level);
	
	get_node("/root/Game/Levels").add_child(levels[next_lvl]);
	next_lvl += 1;
	

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("duality")

	a()
	next_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (OS.get_unix_time() > nextSwitch):
		if (Input.is_action_just_pressed("ui_accept")):
			var m = get_node("/root/Game/Levels/Level/Meditation");
			var p = get_node("/root/Game/Player");
			if (m && p):
				if (p.transform.origin.distance_to(m.transform.origin) < 1.1 || _isSoul):
					nextSwitch = OS.get_unix_time() + 1
					_isSoul = !_isSoul;
					get_tree().call_group("duality", "toggle")

	if (Input.is_action_just_pressed("ui_cancel")):
		print(0)
		next_level();
