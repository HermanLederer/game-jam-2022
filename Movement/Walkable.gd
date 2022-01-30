extends Spatial

export var hasBody = true
export var hasSoul = true

onready var col = $Area

func enable_bit(mask: int, index: int) -> int:
	return mask | (1 << index)

func disable_bit(mask: int, index: int) -> int:
	return mask & ~(1 << index)

func _ready():
	# visible = false;

	print(col.collision_layer)

	var layers = 0;

	if (hasBody): layers = enable_bit(layers, 1)
	if (hasSoul): layers = enable_bit(layers, 5)

	col.collision_layer = layers
	
	print(col.collision_layer)
