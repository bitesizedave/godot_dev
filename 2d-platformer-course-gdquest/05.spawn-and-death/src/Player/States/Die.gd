extends State


func _on_Player_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to('Spawn')


func enter(msg: Dictionary = {}) -> void:
	if owner.camera_rig:
		owner.camera_rig.is_active = true
	owner.hook.visible = false
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_Player_animation_finished")


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Player_animation_finished")
