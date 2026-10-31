class_name InteractableHotspot
extends Button

## Reusable point-and-click hotspot component for Yangon After Hours.
## Works with mouse clicks and mobile touch taps. Supports character avatars and clue discovery.

signal interacted(hotspot: Button)

@export var display_name: String = "Inspectable Object"
@export var speaker_name: String = "Inspect"
@export var is_character: bool = false
@export var avatar_texture: Texture2D
@export_multiline var dialogue_lines: Array[String] = [
	"A curious object in the dark."
]

@export_group("Clue System")
@export var clue_id: String = ""
@export var clue_title: String = ""
@export_multiline var clue_description: String = ""

@export_group("Inspection System")
@export var inspection_target_id: String = ""

@export_group("Questioning / Interrogation")
@export var character_id: String = ""

func _ready() -> void:
	add_to_group("interactable_hotspots")
	pressed.connect(_on_pressed)
	_setup_visuals()

func _setup_visuals() -> void:
	focus_mode = Control.FOCUS_ALL
	
	if is_character:
		text = " 💬 " + display_name
		add_theme_color_override("font_color", Color(0.988235, 0.827451, 0.380392, 1.0))
		add_theme_color_override("font_hover_color", Color(1.0, 0.95, 0.7, 1.0))
		if avatar_texture:
			icon = avatar_texture
			expand_icon = true
			alignment = HORIZONTAL_ALIGNMENT_LEFT
			custom_minimum_size = Vector2(240, 58)
		else:
			custom_minimum_size = Vector2(190, 46)
	else:
		text = " 🔍 " + display_name
		add_theme_color_override("font_color", Color(0.72, 0.86, 0.98, 1.0))
		add_theme_color_override("font_hover_color", Color(0.9, 0.95, 1.0, 1.0))
		if avatar_texture:
			icon = avatar_texture
			expand_icon = true
			alignment = HORIZONTAL_ALIGNMENT_LEFT
			custom_minimum_size = Vector2(210, 52)
		else:
			custom_minimum_size = Vector2(170, 46)

func _on_pressed() -> void:
	interacted.emit(self)

func interact() -> void:
	_on_pressed()
