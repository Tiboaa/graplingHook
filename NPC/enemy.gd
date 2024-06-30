extends CharacterBody2D

@export var health = 1
@export var speed = 20.0
@export var move_zone = 60.0
@export var undead = false
@export var enemy_damage = 1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var anim = $AnimationPlayer
@onready var turnTimer = $TurnTimer
@onready var hitBox = $HitBox
@onready var hurtBox = $HurtBox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var spawn_pos = Vector2.ZERO
var direction = -1.0
var just_turned = false
var knockback_amount = 100

var death_anim = preload("res://NPC/death.tscn")

func _ready():
	anim.play("walk")
	spawn_pos = global_position
	hitBox.damage = enemy_damage

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if absf(global_position.x - spawn_pos.x) >= move_zone and !just_turned:
		direction *= -1
		if sprite.flip_h:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		just_turned = true
		turnTimer.start()

	velocity.x = direction * speed
	move_and_slide()

func death():
	hitBox.collision.call_deferred("set", "disabled", true)
	speed = 0
	var dying = death_anim.instantiate()
	add_child(dying)
	set_collision_layer_value(3, false)
	if undead:
		anim.play("death")
	else:
		sprite.visible = false
		await get_tree().create_timer(2).timeout 
		queue_free()

func _on_turn_timer_timeout():
	just_turned = false

func _on_hurt_box_hurt(damage, _attack_position, _knockback):
	health -= damage
	if health <= 0:
		death()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		anim.play("walk")
		speed = 20.0
		hitBox.collision.call_deferred("set", "disabled", false)
		set_collision_layer_value(3, true)

