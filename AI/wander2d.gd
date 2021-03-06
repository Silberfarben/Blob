# Wanders around, moving a minimum distance of min_wander_distance, and no further than max_wander_distance
class_name Wander2D
extends State


export var max_wander_distance := 5000.0
export var min_wander_distance := 1000.0
export var speed := 1000.0
export var wander_pause := 3.0
export var horizontal_only := true
export var revolve_around_origin := true				# if true, will wander around the origin of the character when this node was ready. Else, random origins will revolve around the characters current position

var raycast := RayCast2D.new()
var timer := Timer.new()

onready var original_origin: Vector2 = get_parent().get_parent().global_transform.origin


func _ready():
	add_child(timer)
	timer.one_shot = true
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "continue_loop")


func _loop() -> void:
	get_parent().goto.one_shot = true
	get_parent().goto.speed = speed
	get_parent().goto.connect("finished", self, "continue_loop")
	
	while active:
		timer.start(wander_pause)
		yield(self, "_continue_loop")
		timer.stop()		# just in case loop was halted and the timer is still running
		
		if not active:
			break
		
		get_parent().goto.enabled = true
		var target_origin: Vector2 = Vector2.UP.rotated(rand_range(0, TAU)) * lerp(min_wander_distance, max_wander_distance, randf()) + original_origin if revolve_around_origin else get_parent().global_transform.origin
		
		if horizontal_only:
			target_origin -= (target_origin - get_parent().get_parent().global_transform.origin).project(get_parent().get_parent().global_transform.y)
		
		get_parent().goto.target_origin = target_origin
		yield(self, "_continue_loop")
	
	get_parent().goto.enabled = false
	get_parent().goto.disconnect("finished", self, "continue_loop")
	emit_signal("loop_finished")
