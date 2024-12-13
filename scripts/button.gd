extends Node2D

@onready var button = $Button
@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer

func _ready() -> void:
	# Start with the idle animation
	animation.play("idle")
	# Set the loop behavior for idle animation
	animation.sprite_frames.set_animation_loop("idle", false)

	# Ensure the Timer is stopped initially
	timer.stop()

	# Connect button signals
	button.pressed.connect(_on_button_pressed)
	button.button_up.connect(_on_button_button_up)
	button.button_down.connect(_on_button_button_down)

func _on_button_button_down() -> void:
	# Play the 'press' animation
	animation.play("press")
	# Set the loop behavior for press animation
	animation.sprite_frames.set_animation_loop("press", false)

	# Start the Timer for the press animation duration
	var press_duration = calculate_animation_duration("press")
	timer.start(press_duration)

func _on_button_pressed() -> void:
	# Play the 'pressed' animation (if needed for a specific action, else remove this)
	animation.play("pressed")
	# Set the loop behavior for pressed animation
	animation.sprite_frames.set_animation_loop("pressed", false)

	# You may choose to set a timer here if you want to wait before returning to idle

func _on_button_button_up() -> void:
	# Play the 'release' animation
	animation.play("release")
	# Set the loop behavior for release animation
	animation.sprite_frames.set_animation_loop("release", false)

	# Start the Timer for the release animation duration
	var release_duration = calculate_animation_duration("release")
	timer.start(release_duration)

# This function calculates the animation duration based on the number of frames and FPS
func calculate_animation_duration(animation_name: String) -> float:
	# Get the number of frames in the animation
	var frames = animation.sprite_frames.get_frame_count(animation_name)
	# Get the FPS of the animation (from the SpriteFrames resource)
	var fps = animation.sprite_frames.get_animation_speed(animation_name)
	# Calculate the duration (frames / fps)
	return frames / fps

func _on_Timer_timeout():
	# When the timer finishes, play the idle animation
	animation.play("idle")
	# Set the loop behavior for idle animation
	animation.sprite_frames.set_animation_loop("idle", false)
