extends Node2D

@onready var start_button = $Start_Button
@onready var options_button = $Options_Button
@onready var quit_button = $Quit_Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.label.text = "Start"
	start_button.button.pressed.connect(_start_button_pressed)
	options_button.label.text = "Options"
	options_button.label.position.x = -30
	options_button.button.pressed.connect(_options_button_pressed)
	quit_button.label.text = "Quit"
	quit_button.button.pressed.connect(_quit_button_pressed)

func _start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/board.tscn")

func _options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/board.tscn")
	
func _quit_button_pressed() -> void:
	get_tree().quit()
