extends Control

@onready var location_title_label: Label = %LocationTitleLabel
@onready var location_subtitle_label: Label = %LocationSubtitleLabel
@onready var location_description_label: Label = %LocationDescriptionLabel
@onready var visual_placeholder: ColorRect = %VisualPlaceholder
@onready var visual_title_label: Label = %VisualTitleLabel
@onready var back_to_map_button: Button = %BackToMapButton

func _ready() -> void:
	back_to_map_button.pressed.connect(_on_back_to_map_pressed)
	_update_location_display()

func _update_location_display() -> void:
	var data: Dictionary = GameState.get_current_location_data()
	location_title_label.text = data.get("title", "Unknown Location")
	location_subtitle_label.text = data.get("subtitle", "")
	location_description_label.text = data.get("description", "")
	
	if visual_placeholder:
		visual_placeholder.color = data.get("color", Color(0.15, 0.15, 0.2, 1.0))
	
	if visual_title_label:
		visual_title_label.text = "[ %s Scene Viewport ]" % data.get("title", "Location")

func _on_back_to_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/city_map.tscn")
