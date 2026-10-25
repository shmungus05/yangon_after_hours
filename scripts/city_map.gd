extends Control

## Interactive City Map for Yangon After Hours.
## Displays the stylized pixel-art map with clickable district pins, navigation bar, and notebook access.

@onready var downtown_pin: Button = %DowntownPin
@onready var tea_shop_pin: Button = %TeaShopPin
@onready var market_pin: Button = %MarketPin

@onready var downtown_button: Button = %DowntownButton
@onready var tea_shop_button: Button = %TeaShopButton
@onready var market_button: Button = %MarketButton

@onready var back_button: Button = %BackToMenuButton
@onready var preview_title_label: Label = %PreviewTitleLabel
@onready var preview_desc_label: Label = %PreviewDescLabel

@onready var notebook_button: Button = %NotebookButton
@onready var notebook_panel: NotebookPanel = %NotebookPanel

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
	
	# Notebook button
	if notebook_button:
		var count: int = GameState.get_clue_count()
		notebook_button.text = "📓 Notebook (%d)" % count
		notebook_button.pressed.connect(func():
			if notebook_panel:
				notebook_panel.open_notebook()
		)
	
	# Default preview
	_preview_location("downtown")

func _preview_location(loc_id: String) -> void:
	var data: Dictionary = GameState.get_location_data(loc_id)
	preview_title_label.text = data.get("title", "") + " — " + data.get("subtitle", "")
	preview_desc_label.text = data.get("description", "")

func _on_location_selected(loc_id: String) -> void:
	GameState.go_to_location(loc_id)

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
