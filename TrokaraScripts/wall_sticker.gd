class_name WallSticker
extends ClassicCharacter2D


export var reorientation_weight := 12.0
export var jump_path: NodePath = "CharacterJump"

onready var jump_node: CharacterJump = get_node(jump_path)


func _process(delta):
	if is_on_floor():
		rotate(global_transform.y.angle_to(- floor_collision[SerialEnums.NORMAL]) * reorientation_weight * delta)

	else:
		rotate(global_transform.y.angle_to(down_vector) * reorientation_weight * delta)
