extends Control

const Localization = preload("res://scripts/localization.gd")

## Interactive City Map for Yangon After Hours.
## Displays the stylized pixel-art map with clickable district pins, navigation bar, and notebook access.

@onready var downtown_pin: Button = %DowntownPin
@onready var tea_shop_pin: Button = %TeaShopPin
@onready var market_pin: Button = %MarketPin

@onready var downtown_button: Button = %DowntownButton
@onready var tea_shop_button: Button = %TeaShopButton
@onready var market_button: Button = %MarketButton

@onready var back_button: Button = %BackToMenuButton
@onready var title_label: Label = %TitleLabel
@onready var status_label: Label = %StatusLabel
@onready var map_lang_button: Button = %MapLangButton
@onready var preview_title_label: Label = %PreviewTitleLabel
@onready var preview_desc_label: Label = %PreviewDescLabel

@onready var notebook_button: Button = %NotebookButton
@onready var notebook_panel: NotebookPanel = %NotebookPanel

var _current_preview_loc: String = "downtown"

func _get_game_state() -> Node:
	var gs = get_node_or_null("/root/GameState")
	if gs:
		return gs
	return GameState

func _ready() -> void:
	# Connect map pins
	downtown_pin.pressed.connect(func(): _on_location_selected("downtown"))
	tea_shop_pin.pressed.connect(func(): _on_location_selected("tea_shop"))
	market_pin.pressed.connect(func(): _on_location_selected("market"))
	
	# Connect bottom destination buttons
	downtown_button.pressed.connect(func(): _on_location_selected("downtown"))
	tea_shop_button.pressed.connect(func(): _on_location_selected("tea_shop"))
	market_button.pressed.connect(func(): _on_location_selected("market"))
	
	# Connect preview hovers for desktop & focus for touch/keyboard
	downtown_pin.mouse_entered.connect(func(): _preview_location("downtown"))
	tea_shop_pin.mouse_entered.connect(func(): _preview_location("tea_shop"))
	market_pin.mouse_entered.connect(func(): _preview_location("market"))
	
	downtown_button.mouse_entered.connect(func(): _preview_location("downtown"))
	tea_shop_button.mouse_entered.connect(func(): _preview_location("tea_shop"))
	market_button.mouse_entered.connect(func(): _preview_location("market"))
	
	# Back button
	back_button.pressed.connect(_on_back_to_menu_pressed)
	
	# Language button
	if map_lang_button:
		map_lang_button.pressed.connect(_on_lang_button_pressed)
	
	# Notebook button
	if notebook_button:
		notebook_button.pressed.connect(func():
			if notebook_panel:
				notebook_panel.open_notebook()
		)
	
	# React to language changes
	var gs = _get_game_state()
	if gs:
		gs.language_changed.connect(_on_language_changed)
		gs.clue_added.connect(func(_id, _desc): _update_notebook_button())
	
	_update_localized_ui()

func _update_localized_ui() -> void:
	var gs = _get_game_state()
	var lang: String = gs.get_language() if gs else "my"
	
	if back_button:
		back_button.text = Localization.get_ui_text("MAP_BACK_MENU", lang)
	if title_label:
		title_label.text = Localization.get_ui_text("MAP_TITLE", lang)
	if status_label:
		status_label.text = Localization.get_ui_text("MAP_SUBTITLE", lang)
	if map_lang_button:
		map_lang_button.text = "မြန်မာ" if lang == "my" else "English"
	if downtown_button:
		var dt = gs.get_location_data("downtown") if gs else {}
		downtown_button.text = dt.get("title", "Downtown")
	if tea_shop_button:
		var ts = gs.get_location_data("tea_shop") if gs else {}
		tea_shop_button.text = ts.get("title", "Tea Shop")
	if market_button:
		var mk = gs.get_location_data("market") if gs else {}
		market_button.text = mk.get("title", "Market")
	
	_update_notebook_button()
	_preview_location(_current_preview_loc)

func _update_notebook_button() -> void:
	if notebook_button:
		var gs = _get_game_state()
		var count: int = gs.get_clue_count() if gs else 0
		var lang: String = gs.get_language() if gs else "my"
		var fmt: String = Localization.get_ui_text("NOTEBOOK_BTN", lang)
		notebook_button.text = fmt % count

func _preview_location(loc_id: String) -> void:
	_current_preview_loc = loc_id
	var gs = _get_game_state()
	var data: Dictionary = gs.get_location_data(loc_id) if gs else {}
	if preview_title_label:
		preview_title_label.text = data.get("title", "") + " — " + data.get("subtitle", "")
	if preview_desc_label:
		preview_desc_label.text = data.get("description", "")

func _on_location_selected(loc_id: String) -> void:
	var gs = _get_game_state()
	if gs:
		gs.go_to_location(loc_id)

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_lang_button_pressed() -> void:
	var gs = _get_game_state()
	if gs:
		gs.toggle_language()

func _on_language_changed(_lang: String) -> void:
	_update_localized_ui()
