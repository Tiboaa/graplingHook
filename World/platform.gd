#Change Type
extends CharacterBody2D

#Make it move 2D
@export var speed = 20.0
@export var move_zone = 60.0
@export var direction = -1.0
@export var horizontal = false
var spawn_pos = Vector2.ZERO

func _ready():
	spawn_pos = global_position

func _physics_process(delta):
	if horizontal:
		if absf(global_position.x - spawn_pos.x) >= move_zone:
			direction *= -1
		velocity.x = direction * speed
	else:
		if absf(global_position.y - spawn_pos.y) >= move_zone:
			direction *= -1
		velocity.y = direction * speed

	move_and_slide()
