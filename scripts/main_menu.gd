extends Control

@onready var start_button = $Start_Button
@onready var options_button = $Options_Button
@onready var quit_button = $Quit_Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_settings()
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
	get_tree().change_scene_to_file("res://scenes/options.tscn")
	
func _quit_button_pressed() -> void:
	get_tree().quit()

func _load_settings() -> void:
	var save_path = "res://save/options_save_file.save"
	var dice = AudioServer.get_bus_index("Dice")
	var master = AudioServer.get_bus_index("Master")
	
	var volume = 50
	var muted = false
	var resolution = 0
	
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		volume = file.get_var()
		muted = file.get_var()
		resolution = file.get_var()
	
	_change_volume(volume, dice, master)
	_change_resolution(resolution)
	_mute(muted, dice, master)
	
func _change_volume(value: int, dice: int, master: int) -> void:
	var mapped_value = 0.0
	
	if value <= 50:
		# Map linearly from 0 -> -40 to 50 -> 0
		mapped_value = -40 + (value / 50.0) * 40  # Slope: 40 / 50
	else:
		# Map linearly from 50 -> 0 to 100 -> 6
		mapped_value = 0 + ((value - 50.0) / 50.0) * 6  # Slope: 6 / 50
	
	# Set the audio bus volumes based on the mapped value
	AudioServer.set_bus_volume_db(dice, mapped_value - 20)
	AudioServer.set_bus_volume_db(master, mapped_value)
	
func _change_resolution(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(DisplayServer.screen_get_size())
		1:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		3:
			DisplayServer.window_set_size(Vector2i(720,480))

func _mute(toggled_on: bool, dice: int, master: int) -> void:
	AudioServer.set_bus_mute(dice, toggled_on)
	AudioServer.set_bus_mute(master, toggled_on)
