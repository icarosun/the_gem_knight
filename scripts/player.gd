extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@onready var animated_sprite = $AnimatedSprite2D

var is_attacking = false
var sword_hit

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0: 
		animated_sprite.flip_h = false
		animated_sprite.position.x = direction * 28
		sword_hit = $AttackcollisionRight/sword_right
	elif direction < 0:
		animated_sprite.flip_h = true
		animated_sprite.position.x = direction * 45
		sword_hit = $AttackcollisionLeft/sword_left
	
	if is_attacking == false:
		animated_sprite.play("idle")
		
	if Input.is_action_just_pressed("fight"):
		animated_sprite.play("attack")
		sword_hit.disabled = false
		is_attacking = true

	move_and_slide()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		sword_hit.disabled = true
		is_attacking = false
