extends Spatial

var _meshBody
var _meshSoul

var _isSoul

func disableMesh(mesh:MeshInstance) :
	mesh.visible = false;

func enableMesh(mesh:MeshInstance) :
	mesh.visible = true;

func switchToSoul():
	disableMesh(_meshBody)
	enableMesh(_meshSoul)
	_isSoul = true

func switchToBody():
	disableMesh(_meshSoul)
	enableMesh(_meshBody)
	_isSoul = false
	
func toggle():
	if (_isSoul): switchToBody()
	else: switchToSoul()

# Called when the node enters the scene tree for the first time.
func _ready():
	_meshBody = get_child(0)
	_meshSoul = get_child(1)
	
	switchToBody()
	
	# _meshBody.remove_child()

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")): toggle()
