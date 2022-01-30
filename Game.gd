extends Spatial

var _isSoul = false;

var nextSwitch: int = 0;

var levels;
var next_lvl = 0;

var p;

func a():
	levels = get_node("/root/Game/Levels").get_children();
	for level in levels:
		level.visible = true;
		get_node("/root/Game/Levels").remove_child(level);

func next_level():
	get_node("/root/Game/Player").transform.origin = Vector3(0, 1, 1);

	var l = get_node("/root/Game/Levels").get_children();
	for level in l:
		get_node("/root/Game/Levels").remove_child(level);
	
	get_node("/root/Game/Levels").add_child(levels[next_lvl]);
	next_lvl += 1;
	

# Called when the node enters the scene tree for the first time.
func _ready():
	p = get_node("/root/Game/Player");

	add_to_group("duality")

	a()
	next_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (OS.get_unix_time() > nextSwitch):
		if (Input.is_action_just_pressed("ui_accept")):
			var m = get_node("/root/Game/Levels/Level/Meditation");
			if (m):
				if (p.transform.origin.distance_to(m.transform.origin) < 1.1 || _isSoul):
					nextSwitch = OS.get_unix_time() + 1
					_isSoul = !_isSoul;
					get_tree().call_group("duality", "toggle")

	var g = get_node("/root/Game/Levels").get_child(0).get_node("Gate2");

	if (g):
		print(1);
		if (p.transform.origin.distance_to((g.transform.origin)) < 0.1):
			
			next_level();
