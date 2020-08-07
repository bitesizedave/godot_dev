tool
class_name Trail2D
extends Line2D

export var target_path: NodePath
var is_emitting: = true setget set_is_emitting
var max_points: = 1000
var resolution: = 50.0
var lifetime: = 1.0
var _last_point: = Vector2.ZERO
var _points_creation_time: = []
var _clock = 0.0
var _offset: = 0.0

onready var target = get_node_or_null(target_path)

func ready():
	if not target:
		#if we can't get it from the path, fallback to parent node
		target = get_parent() as Node2D
	_offset = position.length()
	#make the transforms global	
	set_as_toplevel(true)
	position = Vector2.ZERO
	#prevent drawing when the game starts
	clear_points()
		
		# Disables the trail's behavior in the Editor
	if Engine.editor_hint:
		set_process(false)
		return

func _process(delta):
	_clock += delta
	remove_older()
	#add new points if necessary
	var desired_point: = to_local(target.global_position)
	var distance: = _last_point.distance_to(desired_point)
	if distance > resolution:
		add_timed_point(desired_point, _clock)


func add_timed_point(point: Vector2, time: float):
	add_point(point + calculate_offset())
	_points_creation_time.append(time)
	_last_point = point
	if get_point_count() > max_points:
		remove_first_point()

#removes the first point in the line and the corresponding time in the array
func remove_first_point():
	if get_point_count() > 1:
		remove_point(0)
	_points_creation_time.pop_front()


func remove_older():
	for creation_time in _points_creation_time:
		var delta = _clock - creation_time
		if delta > lifetime:
			remove_first_point()
		else: break


func set_is_emitting(emitting: bool):
	is_emitting = emitting
	if Engine.editor_hint:
		return
	
	if not is_inside_tree():
		yield(self, "ready")
	
	if is_emitting:
		clear_points()
		_points_creation_time.clear()
		_last_point = to_local(target.global_position)


func _get_configuration_warning() -> String:
	var warning: = "Assign a ding dang Node to the Trail2D ya donkey"
	if target:
		warning = ""
	return warning


func calculate_offset() -> Vector2:
	return -polar2cartesian(1.0, target.rotation) * _offset
