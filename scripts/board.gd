extends Node2D

@onready var button = $Button
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
	# Connect the button's pressed signal to trigger the dice roll
	button.button.pressed.connect(_on_button_pressed)
	
	if dice:
		dice.connect("roll_finished", Callable(self, "_on_dice_roll_finished"))
	
	quota_label.text = quota_label.text + str(quota)
	pigs_label.text = pigs_label.text + str(pigs)
	bank_label.text = bank_label.text + str(bank)
	banked_label.text = banked_label.text + str(banked)
	temp_label.text = temp_label.text + str(temp)

func _on_button_pressed() -> void:
	# Trigger the dice roll when the button is pressed
	if dice:
		dice.call("roll")

func _on_dice_roll_finished(rolled_value: int) -> void:
	# Update the temp value and label when the roll finishes
	if rolled_value == 1:
		pigs += rolled_value
		temp = 0
		pigs_label.text = "Pigs - " + str(pigs)
	else:
		temp += rolled_value
	temp_label.text = "Temp - " + str(temp)
