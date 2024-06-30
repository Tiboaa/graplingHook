extends CharacterBody2D

signal player_death()

@export var health = 20
@export var max_health = 20
@export var player_damage = 1
@export var speed = 120.0
@export var jump_velocity = -300.0

@onready var camera = $Camera2D
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hitBox = $HitBox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var layer = 0
var direction = 0
var knocked_back = 0
var falling = 0

#GUI
@onready var healthBar = $%HealthBar
@onready var pauseMenu = $%PauseMenu
@onready var quitButton = $%QuitButton
@onready var returnButton = $%ReturnButton
@onready var deadLabel = $%DeadLabel

func _input(event):
	if event.is_action_pressed("escape") and !pauseMenu.visible:
		pauseMenu.visible = true
		get_tree().paused = true


func _ready():
	hitBox.damage = player_damage
	pauseMenu.visible
	_on_hurt_box_hurt(0, Vector2.ZERO, 0)

func _physics_process(delta):
	movement(delta)

func movement(delta):
	#Get the input
	direction = Input.get_axis("left", "right")
	var smash = Input.is_action_just_pressed("smash_down")
	
	if falling > 100:
		_on_hurt_box_hurt(2, Vector2.ZERO, 0)
	#Add the gravity & Anim
	if not is_on_floor():
		falling += 1
		velocity.y += gravity * delta
		anim.play("jump")
		if smash:
			hitBox.collision.call_deferred("set", "disabled", false)
			velocity.y += 300
			
	elif is_on_floor():
		falling = 0
		hitBox.collision.call_deferred("set", "disabled", true)
		if direction != 0:
			anim.play("walk")
		else:
			anim.play("idle")
	
	#Camera movement
	if global_position.y <= get_viewport_rect().size.y * (layer - 1) +50 :
		camera.limit_bottom -= get_viewport_rect().size.y
		camera.limit_top -= get_viewport_rect().size.y
		layer -= 1
	elif global_position.y >= get_viewport_rect().size.y * (layer + 1) -150:
		camera.limit_bottom += get_viewport_rect().size.y
		camera.limit_top += get_viewport_rect().size.y
		layer += 1
	
	#Movement anim direction
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	#Handle movement
	if knocked_back != 0:
		velocity.x = knocked_back
		if knocked_back > 10:
			knocked_back -= 10
		elif knocked_back < 10:
			knocked_back += 10
		else:
			knocked_back = 0
	else:
		velocity.x = direction * speed
	
	#Handle jump
	if Input.is_action_just_pressed("jump") and  is_on_floor():
		velocity.y = jump_velocity
	
	move_and_slide()

func _on_hurt_box_hurt(damage, attack_position, knockback):
	health -= damage
	if health <= 0:
		death()
	print(health)
	healthBar.max_value = max_health
	healthBar.value = health
	if attack_position.x >= global_position.x:
		knocked_back -= knockback
	elif attack_position.x < global_position.x:
		knocked_back += knockback

func _on_return_button_click_end():
	pauseMenu.visible = false
	get_tree().paused = false

func _on_quit_button_click_end():
	get_tree().quit()

func death():
	deadLabel.visible = true
	await get_tree().create_timer(2).timeout
	emit_signal("player_death")


