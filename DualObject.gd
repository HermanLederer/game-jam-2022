extends Spatial

var _meshBody: Spatial
var _meshSoul: Spatial

var _isSoul

export var hasBody = true
export var hasSoul = true

var _isAnimating = false
var _t: float = 0
var _animCallback: FuncRef

func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var q2 = p2.linear_interpolate(p3, t)

	var r0 = q0.linear_interpolate(q1, t)
	var r1 = q1.linear_interpolate(q2, t)

	var s = r0.linear_interpolate(r1, t)
	return s

func animate(callback: FuncRef):
	
	var delay = get_node("/root/Game/Player").transform.origin.distance_to(transform.origin.floor()) / 10.0;
	yield(get_tree().create_timer(delay), "timeout")
	
	_t = 0;
	_isAnimating = true
	_animCallback = callback

func disableMesh(mesh: Spatial):
	mesh.visible = false

func enableMesh(mesh: Spatial):
	mesh.visible = true

func switch_to_soul():
	if (hasBody): disableMesh(_meshBody)
	if (hasSoul): enableMesh(_meshSoul)
	_isSoul = true

func switch_to_body():
	if (hasSoul): disableMesh(_meshSoul)
	if (hasBody): enableMesh(_meshBody)
	_isSoul = false
	
func toggle():
	if (_isSoul): animate(funcref(self, "switch_to_body"))
	else: animate(funcref(self, "switch_to_soul"))

# Called when the node enters the scene tree for the first time.
func _ready():
	_meshBody = get_child(0)
	_meshSoul = get_child(1)
	
	disableMesh(_meshBody)
	disableMesh(_meshSoul)
	
	switch_to_body()

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")): toggle()
	
	if (_isAnimating):
		_t += delta * 10;
		
		if (_t >= PI):
			_meshBody.transform.origin.y = 0;
			_meshSoul.transform.origin.y = 0;
			_animCallback.call_func()
			_isAnimating = false;
		else:
			_meshBody.transform.origin.y = _cubic_bezier(Vector2(0, 0), Vector2(0.5, 0.5), Vector2(1, 2), Vector2(0, 0), _t / PI).y
			_meshSoul.transform.origin.y = _cubic_bezier(Vector2(0, 0), Vector2(0.5, 0.5), Vector2(1, 2), Vector2(0, 0), _t / PI).y
