extends Node2D

@onready var start_button = $Start_Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button.pressed.connect(_start_button_pressed)

func _start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/board.tscn")
