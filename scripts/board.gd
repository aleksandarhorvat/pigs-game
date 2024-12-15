extends Node2D

@onready var roll_button = $Roll_Button
@onready var bank_button = $Bank_Button
@onready var dice = $Dice
@onready var quota_label = $Quota
@onready var pigs_label = $Pigs
@onready var bank_label = $Bank
@onready var banked_label = $Banked
@onready var temp_label = $Temp

var quota: int = 100
var pigs: int = 0
var bank: int = 5
var banked: int = 0
var temp: int = 0

func _ready() -> void:
	# Connect the buttons' pressed signals
	roll_button.button.pressed.connect(_on_roll_button_pressed)
	bank_button.button.pressed.connect(_on_bank_button_pressed)

	if dice:
		dice.connect("roll_finished", Callable(self, "_on_dice_roll_finished"))

	quota_label.text = quota_label.text + str(quota)
	pigs_label.text = pigs_label.text + str(pigs)
	bank_label.text = bank_label.text + str(bank)
	banked_label.text = banked_label.text + str(banked)
	temp_label.text = temp_label.text + str(temp)

func _on_roll_button_pressed() -> void:
	# Trigger the dice roll when the button is pressed
	if dice:
		dice.call("roll")

func _on_bank_button_pressed() -> void:
	# Bank the temporary score if conditions are met
	if bank > 0 and temp > 0:
		banked += temp
		temp = 0
		bank -= 1

		# Update labels
		banked_label.text = "Banked - " + str(banked)
		temp_label.text = "Temp - " + str(temp)
		bank_label.text = "Bank - " + str(bank)

	# Disable bank button if bank is 0
	if bank <= 0:
		bank_button.button.disabled = true

	# Check for game-over condition
	_check_end_game()

func _on_dice_roll_finished(rolled_value: int) -> void:
	# Update the temp value and label when the roll finishes
	if rolled_value == 1:
		pigs += rolled_value
		temp = 0
		pigs_label.text = "Pigs - " + str(pigs)

		# Check if pigs reach 5 to end game
		if pigs >= 5:
			_end_game("Game Over: Too many pigs!")
	else:
		temp += rolled_value
	temp_label.text = "Temp - " + str(temp)

func _check_end_game() -> void:
	if bank <= 0:
		if banked != quota:
			_end_game("Game Over: Failed to meet quota!")

func _end_game(message: String) -> void:
	# Display end game message and disable inputs
	print(message)
	roll_button.button.disabled = true
	bank_button.button.disabled = true
	dice.set_process(false)
