extends Control

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	
	# Web/HTML5 exports do not support quitting the application
	if OS.has_feature("web"):
		quit_button.visible = false
	else:
		quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/city_map.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
