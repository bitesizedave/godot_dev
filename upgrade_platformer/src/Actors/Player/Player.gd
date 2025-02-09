extends Actor
class_name Player

onready var state_machine: StateMachine = $StateMachine
onready var trail: Trail2D = $PlayerTrail2D
onready var collider: CollisionShape2D = $CollisionShape2D
onready var shaking_camera: Camera2D = $CameraRig/ShakingCamera

var is_active: = true setget set_is_active
const PASSTHROUGH_BIT_LAYER: = 3


func _ready():
	WorldData.connect("instant_battle_started", self, "_on_instant_battle_started")
	trail.set_emitting(false)

func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value


func _on_dash_started():
	set_collision_mask_bit(PASSTHROUGH_BIT_LAYER, false)
	trail.set_emitting(true)


func _on_dash_ended():
	set_collision_mask_bit(PASSTHROUGH_BIT_LAYER, true)
	#need to yield a bit because the "end" of the dash is technically Move State
	yield(get_tree().create_timer(0.06), "timeout")
	trail.set_emitting(false)

func _on_instant_battle_started():
	position = PlayerData.player_game_start_position
