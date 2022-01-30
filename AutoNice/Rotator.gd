extends Spatial

export var rotate_x = false
export var rotate_y = false
export var rotate_z = false

export var opffset_y = false

onready var mesh = $MeshInstance

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	var q = Quat()

	var yaw = 0.0;
	var pitch = 0.0;
	var roll = 0.0;

	if (rotate_x): yaw = rng.randi_range(0, 3) * 90.0
	if (rotate_y): pitch = rng.randi_range(0, 3) * 90.0
	if (rotate_z): roll = rng.randi_range(0, 3) * 90.0

	q.set_euler(Vector3(yaw, pitch, roll));
	transform.basis = Basis(q)

	if (opffset_y): transform.origin.y += rng.randf_range(-0.1, 0.1)
