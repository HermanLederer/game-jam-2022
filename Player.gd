extends Spatial

export (int, LAYERS_2D_PHYSICS) var walkable_layers_body = 0
export (int, LAYERS_2D_PHYSICS) var walkable_layers_soul = 0
export (int, LAYERS_2D_PHYSICS) var translation_layers_body = 0
export (int, LAYERS_2D_PHYSICS) var translation_layers_soul = 0

var _isSoul = false;

func move(direction:Vector3, height: float):
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
	raycastOrgn = global_transform.origin + Vector3(-0.5, 0.5 + height, 0.5)
	raycastOrgn += direction;
	result = space_state.intersect_ray(raycastOrgn, raycastOrgn + Vector3(0, -1 - height, 0), [], walkable_layers, true, true)
	if (result):
		transform.origin += direction
		var dest = result.get("position")
		dest -= Vector3(-0.5, 1, 0.5)
		global_transform.origin = dest
		return

	# Translations
	raycastOrgn = global_transform.origin + Vector3(-0.5, 2.5, 0.5)
	raycastOrgn += direction;
	result = space_state.intersect_ray(raycastOrgn, raycastOrgn + Vector3(0, -2 - height, 0), [], translation_layers, true, true)
	if (result):
		transform.origin += direction
		var dest = result.get("position")
		dest -= Vector3(-0.5, 1, 0.5)
		global_transform.origin = dest
		move(direction, 2)
		return

func toggle():
	_isSoul = !_isSoul;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("duality")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = Vector3.ZERO
	
	if (Input.is_action_just_pressed("ui_right")): offset.x -= 1;
	if (Input.is_action_just_pressed("ui_left")): offset.x = 1;
	if (Input.is_action_just_pressed("ui_up")): offset.z += 1;
	if (Input.is_action_just_pressed("ui_down")): offset.z -= 1;
	
	if (offset.length() > 0): move(offset, 1)
