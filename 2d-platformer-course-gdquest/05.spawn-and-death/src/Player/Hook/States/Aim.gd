extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and owner.can_hook():
		_state_machine.transition_to("Aim/Fire")


func physics_process(delta: float) -> void:
	var cast: Vector2 = owner.get_aim_direction() * owner.ray_cast.cast_to.length()
	var angle: = cast.angle()
	owner.ray_cast.cast_to = cast
	owner.arrow.rotation = angle
	owner.snap_detector.rotation = angle
	owner.ray_cast.force_raycast_update()
