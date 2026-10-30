extends Control

const Localization = preload("res://scripts/localization.gd")

## Main Menu controller for Yangon After Hours.
## Supports bilingual language toggling between English and Burmese (Myanmar Unicode).

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var play_button: Button = %PlayButton
@onready var language_button: Button = %LanguageButton
@onready var lang_button: Button = %LanguageButton
@onready var quit_button: Button = %QuitButton
@onready var instr_title_label: Label = %InstrTitleLabel
@onready var instr_desc_label: Label = %InstrDescLabel
@onready var footer_label: Label = %FooterLabel

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	language_button.pressed.connect(_on_language_pressed)
	
	if OS.has_feature("web"):
		quit_button.visible = false
	else:
		quit_button.pressed.connect(_on_quit_pressed)
	
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.language_changed.connect(_on_language_changed)
	
	_update_ui()
	play_button.grab_focus()

func _update_ui() -> void:
	var game_state = get_node_or_null("/root/GameState")
	var lang: String = game_state.get_language() if game_state else "my"
	
	if title_label:
		title_label.text = Localization.get_ui_text("MENU_TITLE", lang)
	if subtitle_label:
		subtitle_label.text = Localization.get_ui_text("MENU_SUBTITLE", lang)
	if play_button:
		play_button.text = Localization.get_ui_text("MENU_PLAY", lang)
	if quit_button:
		quit_button.text = Localization.get_ui_text("MENU_QUIT", lang)
	if language_button:
		if lang == "my":
			language_button.text = "🌐 ဘာသာစကား - မြန်မာစာ (Language: Myanmar)"
		else:
			language_button.text = "🌐 Language: English (ဘာသာစကား - အင်္ဂလိပ်)"
	if instr_title_label:
		instr_title_label.text = Localization.get_ui_text("HOW_TO_PLAY_TITLE", lang)
	if instr_desc_label:
		instr_desc_label.text = Localization.get_ui_text("HOW_TO_PLAY_DESC", lang)
	if footer_label:
		footer_label.text = Localization.get_ui_text("MENU_FOOTER", lang)

func _on_language_pressed() -> void:
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.toggle_language()

func _on_language_changed(_new_lang: String) -> void:
	_update_ui()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/city_map.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
