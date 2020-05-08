extends Control

# Joypads demo, written by Dana Olson <dana@shineuponthee.com>
#
# This is a demo of joypad support, and doubles as a testing application
# inspired by and similar to jstest-gtk.
#
# Licensed under the MIT license

const DEADZONE = 0.2

var joy_num
var cur_joy = -1
var axis_value

onready var axes = $Axes
onready var button_grid = $Buttons/ButtonGrid
onready var joypad_axes = $JoypadDiagram/Axes
onready var joypad_buttons = $JoypadDiagram/Buttons
onready var joypad_name = $DeviceInfo/JoyName
onready var joypad_number = $DeviceInfo/JoyNumber

func _ready():
	set_physics_process(true)
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")


func _process(_delta):
	# Get the joypad device number from the spinbox.
	joy_num = joypad_number.get_value()

	# Display the name of the joypad if we haven't already.
	if joy_num != cur_joy:
		cur_joy = joy_num
		joypad_name.set_text(Input.get_joy_name(joy_num))

	# Loop through the axes and show their current values.
	for axis in range(JOY_AXIS_MAX):
		axis_value = Input.get_joy_axis(joy_num, axis)
		axes.get_node("Axis" + str(axis) + "/ProgressBar").set_value(100 * axis_value)
		axes.get_node("Axis" + str(axis) + "/ProgressBar/Value").set_text(str(axis_value))
		# Show joypad direction indicators
		if axis <= JOY_ANALOG_RY:
			if abs(axis_value) < DEADZONE:
				joypad_axes.get_node(str(axis) + "+").hide()
				joypad_axes.get_node(str(axis) + "-").hide()
			elif axis_value > 0:
				joypad_axes.get_node(str(axis) + "+").show()
				joypad_axes.get_node(str(axis) + "-").hide()
			else:
				joypad_axes.get_node(str(axis) + "+").hide()
				joypad_axes.get_node(str(axis) + "-").show()

	# Loop through the buttons and highlight the ones that are pressed.
	for btn in range(JOY_BUTTON_0, JOY_BUTTON_MAX):
		if Input.is_joy_button_pressed(joy_num, btn):
			button_grid.get_node(str(btn)).add_color_override("font_color", Color.white)
			joypad_buttons.get_node(str(btn)).show()
		else:
			button_grid.get_node(str(btn)).add_color_override("font_color", Color(0.2, 0.1, 0.3, 1))
			joypad_buttons.get_node(str(btn)).hide()


# Called whenever a joypad has been connected or disconnected.
func _on_joy_connection_changed(device_id, connected):
	if device_id == cur_joy:
		joypad_name.set_text(Input.get_joy_name(device_id) if connected else "")


func _on_start_vibration_pressed():
	var weak = $Vibration/Weak/Value.get_value()
	var strong = $Vibration/Strong/Value.get_value()
	var duration = $Vibration/Duration/Value.get_value()
	Input.start_joy_vibration(cur_joy, weak, strong, duration)


func _on_stop_vibration_pressed():
	Input.stop_joy_vibration(cur_joy)
