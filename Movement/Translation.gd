extends Spatial

export var hasBody = true
export var hasSoul = true

onready var col = $Area

func _ready():
	# visible = false;

	col.set_collision_layer_bit(2, hasBody)
	col.set_collision_layer_bit(6, hasSoul)
	pass
