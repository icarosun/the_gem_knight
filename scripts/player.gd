extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@onready var animated_sprite = $AnimatedSprite2D

var is_attacking = false
var attack_animation_playing = false  # Flag para saber se a animação de ataque está tocando

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
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Verifica se o personagem iniciou o ataque
	if Input.is_action_just_pressed("fight") and not is_attacking and not attack_animation_playing:
		is_attacking = true
		attack_animation_playing = true  # Marca que a animação de ataque começou

	# Se o personagem não está atacando, usa a animação idle
	if !is_attacking and animated_sprite.animation != "idle":
		animated_sprite.play("idle")
	
	# Se o personagem está atacando, usa a animação de ataque
	if is_attacking and animated_sprite.animation != "attack":
		animated_sprite.play("attack")
	
	# Quando a animação de ataque terminar, volta para idle
	if animated_sprite.animation == "attack" and not attack_animation_playing:
		is_attacking = false
	
	# Controla a flag de animação de ataque
	if animated_sprite.animation == "attack" and animated_sprite.is_playing() == false:
		attack_animation_playing = false
	
	move_and_slide()
