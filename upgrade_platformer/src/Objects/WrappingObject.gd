extends KinematicBody2D
class_name WrappingObject


onready var main_level = get_parent().owner
var rising_label_animation_distance: = 25.0
var rising_label_animation_time: = 0.5

func _physics_process(delta):
	if WorldData.wrapping:
		self.position = wrap_position(true, true, true, true)
	elif (WorldData.is_in_top_room(self.position)):
		self.position = wrap_position(true, true, false, true)
	elif (WorldData.is_in_bottom_room(self.position)):
		self.position = wrap_position(false, true, true, true)
	elif (WorldData.is_in_right_room(self.position)):
		self.position = wrap_position(true, true, true, false)
	elif (WorldData.is_in_left_room(self.position)):
		self.position = wrap_position(true, false, true, true)
	else: self.position = wrap_position(true, true, true, true)


func wrap_position(top_wrap: bool, right_wrap: bool, bottom_wrap: bool, left_wrap: bool) -> Vector2:
	var new_position: = Vector2(self.position)
	if right_wrap:
		if position.x > WorldData.get_screen_right_edge():
			new_position.x = WorldData.get_screen_left_edge()
	if left_wrap:
		if position.x < WorldData.get_screen_left_edge():
			new_position.x = WorldData.get_screen_right_edge()
	if bottom_wrap:
		if position.y > WorldData.get_screen_bottom_edge():
			new_position.y = WorldData.get_screen_top_edge()
	if top_wrap:
		if position.y < WorldData.get_screen_top_edge():
			new_position.y = WorldData.get_screen_bottom_edge()
	return new_position


func create_rising_label_animation(value: String, transform: Transform2D, color: Color):
	var global_position = get_global_position()
	var label = Label.new()
	main_level.add_child(label)
	label.text = value
	label.modulate = color
	label.modulate.a = 0.8
	label.align = Label.ALIGN_CENTER
	label.rect_global_position = global_position - transform.get_scale()
#	label.rect_global_position = get_global_position() - Vector2(transform.x.x,transform.y.y)*2
	var label_animation = Tween.new()
	add_child(label_animation)
	label_animation.connect("tween_completed", self, "_on_animation_tween_completed")
	label_animation.interpolate_property(label, "rect_position", global_position, 
		Vector2(global_position.x, global_position.y - rising_label_animation_distance),
		rising_label_animation_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	label_animation.start()


func _on_animation_tween_completed(obj: Object, path: NodePath):
	obj.queue_free()
	
