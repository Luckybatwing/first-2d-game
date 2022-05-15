extends Area2D
signal hit

# `export` lets you change the value in Godot's inspector
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

var target = Vector2()  # The clicked pos


func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO  # The player's movement vector.

	# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = target - position

	# if Input.is_action_pressed("move_right"):
	# 	velocity.x += 1
	# if Input.is_action_pressed("move_left"):
	# 	velocity.x -= 1
	# if Input.is_action_pressed("move_down"):
	# 	velocity.y += 1
	# if Input.is_action_pressed("move_up"):
	# 	velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $[name] == get_node("[name]")
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	# `delta` is the FPS of the last frame to ensure consistent movements
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(_body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
