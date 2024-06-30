extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var hurt_box_type = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHurtBox

signal hurt(damage, attack_position, knockback)

func _ready():
	_on_area_entered(self)

func _on_area_entered(area):
	if area.is_in_group('attack'):
		if not area.get("damage") == null:
			var damage = area.damage
			var knockback = 1
			var attack_position = area.global_position
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			
			emit_signal("hurt", damage, attack_position, knockback)
			collision.call_deferred("set", "disabled", true)
			disableTimer.start()

func _on_disable_hurt_box_timeout():
	collision.call_deferred("set", "disabled", false)
