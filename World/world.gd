extends Node2D

var menu = "res://World/main_menu.tscn"

func _on_player_player_death():
	get_tree().change_scene_to_file(menu)
