extends Node2D

@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	# Start the animation
	animation.play("roll")
	animation.offset = Vector2(0, 0)  # Reset the offset

	# Wait for the animation to finish
	await animation.animation_finished
	apply_dice_roll_effects()  # Call a function to handle what happens next

func _process(delta: float) -> void:
	if animation.is_playing():
		# Get the current frame and calculate the offset
		var current_frame = animation.frame
		animation.offset = calculate_offset(current_frame)

func calculate_offset(current_frame: int) -> Vector2:
	# Define the maximum vertical displacement for the animation
	var max_displacement = 10  # Adjust this value as needed

	# Calculate the offset based on a parabolic motion
	# Frames: 0 to 12 (inclusive) with peak at frame 6
	var offset_y = -max_displacement * (1 - (current_frame - 6) * (current_frame - 6) / 36.0)

	# Return the offset vector
	return Vector2(0, offset_y)

func apply_dice_roll_effects() -> void:
	# Handle the outcome of the dice roll animation
	print("Dice animation completed!")
