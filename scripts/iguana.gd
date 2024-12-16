extends Area2D

var dead = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if dead == false:
		$AnimatedSprite2D.play("idle")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		dead = true
		$AnimatedSprite2D.play("Destroyed")

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Destroyed":
		queue_free();
		dead = false
