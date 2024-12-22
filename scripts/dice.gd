extends Node2D

@onready var animation = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D

var current_roll: int = 0  # Store the result of the roll

signal roll_finished(current_roll: int)

func _ready() -> void:
	var bus_index = AudioServer.get_bus_index("Dice")
	AudioServer.set_bus_volume_db(bus_index,-80.0)

func roll() -> void:
	# Play the dice roll animation
	animation_player.play("roll")
	
	# Wait for the animation to finish
	await animation_player.animation_finished
	
	# Generate a random number from 1 to 6
	current_roll = roll_dice()
	
	emit_signal("roll_finished", current_roll)
	
	apply_dice_roll_effects()

func roll_dice() -> int:
	# Generate a random integer between 1 and 6
	return randi() % 6 + 1

func apply_dice_roll_effects() -> void:
	# Switch to the "value" animation without playing it
	animation.play("value")
	animation.sprite_frames.set_animation_loop("value", false)
	animation.stop()  # Stop the animation to show a single frame
	
	# Set the frame corresponding to the rolled value
	var corresponding_frame = current_roll
	animation.frame = corresponding_frame - 1

	# Log the completion of the animation
	print("Dice result displayed: value = ", current_roll)
