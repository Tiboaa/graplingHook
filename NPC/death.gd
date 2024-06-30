extends Sprite2D

signal death_finished()

func _ready():
	$AnimationPlayer.play("death")
	
func _on_animation_player_animation_finished(_anim_name):
	emit_signal("death_finished")
	queue_free()
