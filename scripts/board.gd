extends Node2D

var save_path = "user://save_file.save"

@onready var roll_button = $Roll_Button
@onready var bank_button = $Bank_Button
@onready var dice = $Dice
@onready var quota_label = $Quota
@onready var pigs_label = $Pigs
@onready var bank_label = $Bank
@onready var banked_label = $Banked
@onready var temp_label = $Temp
@onready var audio = $AudioStreamPlayer

var quota: int = 500
var pigs: int = 0
var bank: int = 5
var banked: int = 0
var temp: int = 0
var bankMulti = 1 + (bank * 0.2) - (pigs * 0.1)

func _ready() -> void:
	_load_data()
	bankMulti = 1 + (bank * 0.2) - (pigs * 0.1)
	# Connect the buttons' pressed signals
	roll_button.button.pressed.connect(_on_roll_button_pressed)
	bank_button.button.pressed.connect(_on_bank_button_pressed)

	if dice:
		dice.connect("roll_finished", Callable(self, "_on_dice_roll_finished"))

	quota_label.text = quota_label.text + str(quota)
	pigs_label.text = pigs_label.text + str(pigs)
	bank_label.text = bank_label.text + str(bank)
	banked_label.text = banked_label.text + str(banked)
	temp_label.text = "Temp " + str(temp) + " x Multi " + str(bankMulti)

func _on_roll_button_pressed() -> void:
	# Trigger the dice roll when the button is pressed
	if dice:
		dice.call("roll")

func _on_bank_button_pressed() -> void:
	# Bank the temporary score if conditions are met
	if bank > 0 and temp > 0:
		print("Bank multi: " , bankMulti)
		banked += temp * bankMulti
		temp = 0
		bank -= 1

		# Update labels
		_update_multi()
		banked_label.text = "Banked - " + str(banked)
		temp_label.text = "Temp " + str(temp) + " x Multi " + str(bankMulti)
		bank_label.text = "Bank - " + str(bank)

	# Disable bank button if bank is 0
	if bank <= 0:
		bank_button.button.disabled = true

	# Check for game-over condition
	_check_end_game()

func _on_dice_roll_finished(rolled_value: int) -> void:
	# Update the temp value and label when the roll finishes
	if rolled_value == 1:
		audio.play()
		pigs += rolled_value
		_update_multi()
		print("Bank multi: " , bankMulti)
		temp = 0
		pigs_label.text = "Pigs - " + str(pigs)
	else:
		temp += rolled_value
	temp_label.text = "Temp " + str(temp) + " x Multi " + str(bankMulti)

func _check_end_game() -> void:
	if bank <= 0:
		if banked != quota:
			_end_game("Game Over: Failed to meet quota!")
	elif banked >= quota:
		_end_game("You Win: Quota met!")

func _end_game(message: String) -> void:
	# Display end game message and disable inputs
	_reset_data()
	print(message)
	roll_button.button.disabled = true
	bank_button.button.disabled = true
	dice.set_process(false)

func _update_multi():
	bankMulti = 1 + (bank * 0.2) - (pigs * 0.1)
	if bankMulti < 1:
		_end_game("Multi is lesser then 1")

func _on_main_menu_pressed() -> void:
	_save()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(quota)
	file.store_var(pigs)
	file.store_var(bank)
	file.store_var(banked)
	file.store_var(temp)
	file.close()

func _load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		quota = file.get_var()
		pigs = file.get_var()
		bank = file.get_var()
		banked = file.get_var()
		temp = file.get_var()
		file.close()

func _reset_data() -> void:
	quota = 500
	pigs = 0
	bank = 5
	banked = 0
	temp = 0
	bankMulti = 1 + (bank * 0.2) - (pigs * 0.1)
	
func _on_tree_exiting() -> void:
	_save()

func _on_options_pressed() -> void:
	_save()
	get_tree().change_scene_to_file("res://scenes/options.tscn")
