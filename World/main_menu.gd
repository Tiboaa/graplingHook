extends Control

var level = "res://World/test_world_2.tscn"

func _on_new_game_click_end():
	get_tree().change_scene_to_file(level)
func _on_quit_click_end():
	get_tree().quit()
