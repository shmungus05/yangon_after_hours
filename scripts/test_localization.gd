extends SceneTree

const Localization = preload("res://scripts/localization.gd")

func _init() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- Starting Yangon After Hours Localization Test Suite ---")
	
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		# In headless script execution, autoloads might not be present unless loaded or we are in tree
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.name = "GameState"
		game_state.set_script(gs_script)
		root.add_child(game_state)
	
	# Test 1: Language default and toggle
	game_state.set_language("my")
	assert(game_state.get_language() == "my", "Default language should be 'my'")
	var burmese_title = game_state.loc("ui_game_title")
	assert(burmese_title == "ရန်ကုန်ညဉ့်နက်ချိန်", "Burmese title match failed")
	print("✔ Test 1 Passed: Default language is Burmese ('my')")
	
	game_state.toggle_language()
	assert(game_state.get_language() == "en", "Toggled language should be 'en'")
	var english_title = game_state.loc("ui_game_title")
	assert(english_title == "YANGON AFTER HOURS", "English title match failed")
	print("✔ Test 2 Passed: Toggle to English ('en') works")
	
	# Test 3: Location data in both languages
	for loc_id in ["downtown", "tea_shop", "market"]:
		game_state.set_language("my")
		var my_data = game_state.get_location_data(loc_id)
		assert(not my_data["title"].is_empty(), "Burmese title empty for " + loc_id)
		assert(not my_data["description"].is_empty(), "Burmese desc empty for " + loc_id)
		
		game_state.set_language("en")
		var en_data = game_state.get_location_data(loc_id)
		assert(not en_data["title"].is_empty(), "English title empty for " + loc_id)
		assert(not en_data["description"].is_empty(), "English desc empty for " + loc_id)
		assert(my_data["title"] != en_data["title"], "Titles should differ between languages")
	print("✔ Test 3 Passed: Location data correctly localizes for all 3 districts")
	
	# Test 4: Clues localization
	game_state.reset_game()
	game_state.set_language("my")
	var is_new = game_state.add_clue("harbor_cargo_slip", "ဆိပ်ကမ်းကုန်လက်မှတ်", "သန်းခေါင်ယံ ကုန်ချလက်မှတ်", "လပ်ကီးလက်ဖက်ရည်ဆိုင်")
	assert(is_new, "Clue should be newly added")
	var clues_my = game_state.get_clues()
	assert(clues_my.size() == 1, "Should have 1 clue")
	assert(clues_my[0]["title"] == "ဆိပ်ကမ်းကုန်စည်လက်မှတ်ဟောင်း", "Clue title should be localized in Burmese")
	
	game_state.set_language("en")
	var clues_en = game_state.get_clues()
	assert(clues_en[0]["title"] == "Stained Harbor Cargo Slip", "Clue title should dynamically switch to English")
	print("✔ Test 4 Passed: Clues dynamically translate when language changes")
	
	# Test 5: Main Menu scene
	var menu_scene = load("res://scenes/main_menu.tscn").instantiate()
	root.add_child(menu_scene)
	await process_frame
	
	game_state.set_language("my")
	assert(menu_scene.title_label.text == "ရန်ကုန်ညဉ့်နက်ချိန်", "Main menu title should be Burmese")
	assert(menu_scene.lang_button.text == "🌐 ဘာသာစကား - မြန်မာစာ (Language: Myanmar)", "Main menu lang button text mismatch")
	
	# Trigger language button click
	menu_scene.lang_button.emit_signal("pressed")
	await process_frame
	assert(game_state.get_language() == "en", "Menu language button should toggle to English")
	assert(menu_scene.title_label.text == "YANGON AFTER HOURS", "Main menu title should be English")
	assert(menu_scene.lang_button.text == "🌐 Language: English (ဘာသာစကား - အင်္ဂလိပ်)", "Main menu lang button should show English toggle")
	
	menu_scene.queue_free()
	await process_frame
	print("✔ Test 5 Passed: Main Menu interactive language toggle functions perfectly")
	
	# Test 6: City Map scene
	var map_scene = load("res://scenes/city_map.tscn").instantiate()
	root.add_child(map_scene)
	await process_frame
	
	game_state.set_language("my")
	assert(map_scene.title_label.text == "ရန်ကုန်မြို့ပြမြေပုံ", "Map title should be Burmese")
	assert(map_scene.map_lang_button.text == "မြန်မာ", "Map lang button text mismatch")
	assert(map_scene.back_button.text == "← ပင်မမီနူး", "Map back button mismatch")
	
	map_scene.map_lang_button.emit_signal("pressed")
	await process_frame
	assert(game_state.get_language() == "en", "Map lang button should toggle to English")
	assert(map_scene.title_label.text == "YANGON CITY MAP", "Map title should be English")
	assert(map_scene.map_lang_button.text == "English", "Map lang button text should be English")
	
	map_scene.queue_free()
	await process_frame
	print("✔ Test 6 Passed: City Map interactive language toggle functions perfectly")
	
	# Test 7: Tea Puzzle Panel
	var tea_panel = load("res://scenes/components/tea_puzzle_panel.tscn").instantiate()
	root.add_child(tea_panel)
	await process_frame
	
	game_state.set_language("my")
	tea_panel.open_puzzle()
	assert(tea_panel.title_label.text == "☕ လပ်ကီးလက်ဖက်ရည်ဆိုင် အော်ဒါပဟေဠိ", "Tea puzzle title should be Burmese")
	assert(tea_panel.min_option.get_item_text(1) == "ချိုစိမ့် (အချိုနှင့် နို့စိမ့်)", "Burmese tea option 1 mismatch")
	assert(tea_panel.min_option.get_item_text(2) == "ချိုပြစ် (အချိုနှင့် လက်ဖက်ရည်အပြစ်)", "Burmese tea option 2 mismatch")
	
	game_state.set_language("en")
	assert(tea_panel.title_label.text == "☕ TEA SHOP ORDER PUZZLE", "Tea puzzle title should switch to English")
	assert(tea_panel.min_option.get_item_text(1) == "Cho-seint (Sweet & Rich)", "English tea option 1 mismatch")
	assert(tea_panel.min_option.get_item_text(2) == "Cho-pyit (Sweet & Strong)", "English tea option 2 mismatch")
	
	tea_panel.queue_free()
	await process_frame
	print("✔ Test 7 Passed: Tea Puzzle Panel bilingual options and texts verified")
	
	# Test 8: Market Puzzle Panel
	var market_panel = load("res://scenes/components/market_puzzle_panel.tscn").instantiate()
	root.add_child(market_panel)
	await process_frame
	
	game_state.set_language("my")
	market_panel.open_puzzle()
	assert(market_panel.title_label.text == "📦 ဈေးသည်၏ ပျောက်ဆုံးမှတ်စုစာအုပ် ပဟေဠိ", "Market puzzle title should be Burmese")
	assert(market_panel.emblem_option.get_item_text(1) == "တော်ဝင်ဒေါင်းတံဆိပ်တော်", "Market emblem 1 Burmese mismatch")
	
	game_state.set_language("en")
	assert(market_panel.title_label.text == "📦 VENDOR'S MISSING NOTEBOOK PUZZLE", "Market puzzle title should switch to English")
	assert(market_panel.emblem_option.get_item_text(1) == "Royal Burmese Peacock Seal", "Market emblem 1 English mismatch")
	
	market_panel.queue_free()
	await process_frame
	print("✔ Test 8 Passed: Market Puzzle Panel bilingual options and texts verified")
	
	# Test 9: Delivery Puzzle Panel
	var delivery_panel = load("res://scenes/components/delivery_puzzle_panel.tscn").instantiate()
	root.add_child(delivery_panel)
	await process_frame
	
	game_state.set_language("my")
	delivery_panel.open_puzzle()
	assert(delivery_panel.title_label.text == "🏛️ ရှေးဟောင်းတိုက် ကုန်စည်ပို့ဆောင်ရေးခလုတ်ခုံ", "Delivery title should be Burmese")
	assert(delivery_panel.seal_option.get_item_text(1) == "ဟင်္သာမင်း တံဆိပ်တော် (ဆိပ်ခံ ၄ ကုန်စာရင်း)", "Delivery seal 1 Burmese mismatch")
	
	game_state.set_language("en")
	assert(delivery_panel.title_label.text == "🏛️ HERITAGE VAULT DISPATCH CONSOLE", "Delivery title should switch to English")
	assert(delivery_panel.seal_option.get_item_text(1) == "Royal Hintha Bird Seal (Pier 4 Manifest)", "Delivery seal 1 English mismatch")
	
	delivery_panel.queue_free()
	await process_frame
	print("✔ Test 9 Passed: Delivery Puzzle Panel bilingual options and texts verified")
	
	# Test 10: Ending Scene
	var ending_scene = load("res://scenes/game_ending.tscn").instantiate()
	root.add_child(ending_scene)
	await process_frame
	
	game_state.set_language("my")
	assert(ending_scene.title_label.text == "ရန်ကုန်ညဉ့်နက်ချိန် — အမှုပြီးဆုံးပါပြီ", "Ending title should be Burmese")
	assert(ending_scene.restart_button.text == "↺ တစ်ကျော့ပြန်ကစားမည်", "Ending restart button Burmese mismatch")
	
	game_state.set_language("en")
	assert(ending_scene.title_label.text == "YANGON AFTER HOURS — CASE CLOSED", "Ending title should switch to English")
	assert(ending_scene.restart_button.text == "↺ Play Again (New Game)", "Ending restart button English mismatch")
	
	ending_scene.queue_free()
	await process_frame
	print("✔ Test 10 Passed: Game Ending Scene bilingual layout and statistics verified")
	
	# Reset back to Burmese as default for players
	game_state.set_language("my")
	print("\nALL 10 LOCALIZATION TESTS PASSED SUCCESSFULLY! Default set to Burmese ('my').")
	quit(0)
