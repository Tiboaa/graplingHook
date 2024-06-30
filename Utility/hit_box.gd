extends Area2D

@export var knockback_amount = 10
@export var damage = 1

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBox


func _on_disable_hit_box_timeout():
	pass # Replace with function body.
