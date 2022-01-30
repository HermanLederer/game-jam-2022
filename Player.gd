extends Spatial

export (int, LAYERS_2D_PHYSICS) var walkable_layers_body = 0
export (int, LAYERS_2D_PHYSICS) var walkable_layers_soul = 0
export (int, LAYERS_2D_PHYSICS) var translation_layers_body = 0
export (int, LAYERS_2D_PHYSICS) var translation_layers_soul = 0

var _isSoul = false;

var _t = 0;
var _isAnimating = false;
var _cur = Vector3.ZERO;
var _dest = Vector3.ZERO;

func reset():
	print(1);
	_isAnimating = false;
	global_transform.origin = Vector3(0, 1, 1);

func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var q2 = p2.linear_interpolate(p3, t)

	var r0 = q0.linear_interpolate(q1, t)
	var r1 = q1.linear_interpolate(q2, t)

	var s = r0.linear_interpolate(r1, t)
	return s

func aimate(dest:Vector3):
	_t = 0;
	_isAnimating = true;
	_cur = global_transform.origin;
	_dest = dest;

func move(origin: Vector3, direction:Vector3, height: float):
	if (_isAnimating): return;

	# 
	var walkable_layers = walkable_layers_body
	var translation_layers = translation_layers_body
	if (_isSoul):
		walkable_layers = walkable_layers_soul
		translation_layers = translation_layers_soul

	# Raycast
	var space_state = get_world().direct_space_state
	var result
	var raycastOrgn

	# Walkables
	raycastOrgn = origin + Vector3(-0.5, 0.5 + height, 0.5)
	raycastOrgn += direction;
	result = space_state.intersect_ray(raycastOrgn, raycastOrgn + Vector3(0, -1 - height, 0), [], walkable_layers, true, true)
	if (result):
		# transform.origin += direction
		var dest = result.get("position")
		dest -= Vector3(-0.5, 1, 0.5)
		aimate(dest);
		return

	# Translations
	raycastOrgn = origin + Vector3(-0.5, 2.5, 0.5)
	raycastOrgn += direction;
	result = space_state.intersect_ray(raycastOrgn, raycastOrgn + Vector3(0, -2 - height, 0), [], translation_layers, true, true)
	if (result):
		var dest = result.get("position")
		dest -= Vector3(-0.5, 1, 0.5)
		# global_transform.origin = dest
		move(dest, direction, 2)
		return

func toggle():
	_isSoul = !_isSoul;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("duality")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = Vector3.ZERO
	
	if (Input.is_action_just_pressed("ui_right")): offset.z += 1;
	if (Input.is_action_just_pressed("ui_left")): offset.z -= 1;
	if (Input.is_action_just_pressed("ui_up")): offset.x += 1;
	if (Input.is_action_just_pressed("ui_down")): offset.x -= 1;
	
	if (offset.length() > 0):
		move(global_transform.origin, offset, 1)

	if (_isAnimating):
		_t += delta * 20;
		global_transform.origin = lerp(_cur, _dest, _t / PI);
		global_transform.origin.y += 0.5 * _cubic_bezier(Vector2(0, 0), Vector2(0.5, 0.5), Vector2(1, 2), Vector2(0, 0), _t / PI).y;
		if (_t >= PI):
			_isAnimating = false;
