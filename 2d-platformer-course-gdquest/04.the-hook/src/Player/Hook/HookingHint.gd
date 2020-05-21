tool
extends Node2D
"""Draws a target to indicate if and where the player can hook"""


export var color: Color


func _ready() -> void:
	set_as_toplevel(true)
	update()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, color)
