extends Spatial

var _isSoul = false;

var nextSwitch: int = 0;

var levels;
var next_lvl = 0;

var p;

var _start_t = OS.get_ticks_msec()

onready var _timer = $Timer;

func a():
	levels = get_node("/root/Game/Levels").get_children();
	for level in levels:
		level.visible = true;
		get_node("/root/Game/Levels").remove_child(level);

func next_level():
	print("Next level")

	var l = get_node("/root/Game/Levels").get_children();
	for level in l:
		get_node("/root/Game/Levels").remove_child(level);
	
	get_node("/root/Game/Levels").add_child(levels[next_lvl]);
	next_lvl += 1;

	get_node("/root/Game/Player").reset();
	

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
			var m = get_node("/root/Game/Levels/").get_child(0).get_node("Meditate");
			if (m):
				print(1);
				if (p.global_transform.origin.distance_to(m.global_transform.origin) < 1.1 || _isSoul):
					nextSwitch = OS.get_unix_time() + 1
					_isSoul = !_isSoul;
					get_tree().call_group("duality", "toggle")

	var g = get_node("/root/Game/Levels").get_child(0).get_node("Gate2");

	if (g):
		if (p.global_transform.origin.distance_to((g.global_transform.origin)) < 0.5):
			next_level();
	
	var ms = OS.get_ticks_msec() - _start_t;
	var m = 0;
	var s = 0;
	
	while (ms >= 60000):
		m += 1;
		ms -= 60000;
		
	while (ms >= 1000):
		s += 1;
		ms -= 1000;
	
	var outp = str(m) + ":";
	if (s < 10): outp += "0";
	outp += str(s) + ":"
	outp += str(ms);
	
	_timer.set_text(outp);
