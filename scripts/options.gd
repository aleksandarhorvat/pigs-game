extends Control

var save_path = "res://save/options_save_file.save"

@onready var h_slider = $MarginContainer/VBoxContainer/HSlider
@onready var check = $MarginContainer/VBoxContainer/CheckButton
@onready var options = $MarginContainer/VBoxContainer/OptionButton

var volume = 50
var resolution = 0
var muted: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_data()
	h_slider.value = volume
	check.button_pressed = muted
	options.selected = resolution

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_pressed() -> void:
	_save()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func _on_resume_pressed() -> void:
	_save()
	get_tree().change_scene_to_file("res://scenes/board.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	var dice = AudioServer.get_bus_index("Dice")
	var master = AudioServer.get_bus_index("Master")
	
	# Linearly map the value
	var mapped_value = 0.0
	volume = value
	
	if value <= 50:
		# Map linearly from 0 -> -40 to 50 -> 0
		mapped_value = -40 + (value / 50.0) * 40  # Slope: 40 / 50
	else:
		# Map linearly from 50 -> 0 to 100 -> 6
		mapped_value = 0 + ((value - 50.0) / 50.0) * 6  # Slope: 6 / 50
	
	# Set the audio bus volumes based on the mapped value
	AudioServer.set_bus_volume_db(dice, mapped_value - 20)
	AudioServer.set_bus_volume_db(master, mapped_value)


func _on_tree_exiting() -> void:
	_save()

func _on_check_button_toggled(toggled_on: bool) -> void:
	var dice = AudioServer.get_bus_index("Dice")
	var master = AudioServer.get_bus_index("Master")
	
	muted = toggled_on
	
	AudioServer.set_bus_mute(dice, toggled_on)
	AudioServer.set_bus_mute(master, toggled_on)

func _save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(volume)
	file.store_var(muted)
	file.store_var(resolution)

func _load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		volume = file.get_var()
		muted = file.get_var()
		resolution = file.get_var()


func _on_option_button_item_selected(index: int) -> void:
	resolution = index
	match index:
		0:
			DisplayServer.window_set_size(DisplayServer.screen_get_size())
		1:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		3:
			DisplayServer.window_set_size(Vector2i(720,480))
