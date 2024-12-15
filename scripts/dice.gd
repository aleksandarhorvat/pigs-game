extends Node2D

@onready var animation = $AnimatedSprite2D

var current_roll: int = 0  # Store the result of the roll

signal roll_finished(current_roll: int)

func roll() -> void:
	# Play the dice roll animation
	animation.play("roll")
	animation.sprite_frames.set_animation_loop("roll", false)
	animation.offset = Vector2(0, 0)

	# Wait for the animation to finish
	await animation.animation_finished
	
	# Generate a random number from 1 to 6
	current_roll = roll_dice()
	
	emit_signal("roll_finished", current_roll)
	
	apply_dice_roll_effects()

func roll_dice() -> int:
	# Generate a random integer between 1 and 6
	return randi() % 6 + 1

func _process(delta: float) -> void:
	if animation.is_playing():
		# Get the current frame and calculate the offset
		var current_frame = animation.frame
		animation.offset = calculate_offset(current_frame)

func calculate_offset(current_frame: int) -> Vector2:
	var max_displacement = 100  # Adjust this value as needed
	var offset_y = -max_displacement * (1 - (current_frame - 5) * (current_frame - 6) / 36.0)
	return Vector2(0, offset_y)

func apply_dice_roll_effects() -> void:
	# Switch to the "value" animation without playing it
	animation.play("value")
	animation.sprite_frames.set_animation_loop("value", false)
	animation.stop()  # Stop the animation to show a single frame
	
	# Set the frame corresponding to the rolled value
	var corresponding_frame = current_roll
	animation.frame = corresponding_frame - 1

	# Adjust the offset based on the last frame of the "roll" animation
	animation.offset = Vector2(0, 0)

	# Log the completion of the animation
	print("Dice result displayed: value = ", current_roll)
