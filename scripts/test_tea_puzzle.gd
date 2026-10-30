extends SceneTree

func _initialize() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN TEA SHOP PUZZLE TESTS ---")
	
	var game_state = root.get_node_or_null("GameState")
	if game_state == null:
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.set_script(gs_script)
		game_state.name = "GameState"
		root.add_child(game_state)
		await process_frame
	
	game_state.set_language("en")
	game_state.clear_clues()
	game_state.clear_puzzles()
	assert(game_state.is_puzzle_solved("tea_order_puzzle") == false, "Puzzle should start unsolved")
	
	# Load Tea Shop Scene
	var ts_scene: PackedScene = load("res://scenes/locations/tea_shop.tscn")
	assert(ts_scene != null, "Failed to load Tea Shop scene")
	var tea_shop = ts_scene.instantiate()
	root.add_child(tea_shop)
	await process_frame
	
	# Verify customer hotspots exist and provide clues
	var min_hotspot: InteractableHotspot = tea_shop.get_node("%SayaMinHotspot")
	var thida_hotspot: InteractableHotspot = tea_shop.get_node("%MaThidaHotspot")
	var aung_hotspot: InteractableHotspot = tea_shop.get_node("%KoAungHotspot")
	var orders_hotspot: InteractableHotspot = tea_shop.get_node("%TeaOrdersHotspot")
	var puzzle_panel: TeaPuzzlePanel = tea_shop.get_node("%TeaPuzzlePanel")
	
	assert(min_hotspot != null, "Saya Min hotspot missing")
	assert(thida_hotspot != null, "Ma Thida hotspot missing")
	assert(aung_hotspot != null, "Ko Aung hotspot missing")
	assert(orders_hotspot != null, "Tea Orders hotspot missing")
	assert(puzzle_panel != null, "TeaPuzzlePanel missing")
	
	# Verify dialogue hints
	assert("Cho-pyit" in min_hotspot.dialogue_lines[2], "Saya Min should hint at Cho-pyit")
	assert("Cho-seint" in thida_hotspot.dialogue_lines[2], "Ma Thida should hint at Cho-seint")
	assert("Pawt-seint" in aung_hotspot.dialogue_lines[2], "Ko Aung should hint at Pawt-seint")
	print("✔ Test 1: Customer dialogue clues verified.")
	
	# Test opening puzzle via hotspot
	assert(puzzle_panel.visible == false, "Puzzle should start closed")
	orders_hotspot.pressed.emit()
	await process_frame
	assert(puzzle_panel.visible == true, "Puzzle should open when clicking TeaOrdersHotspot")
	print("✔ Test 2: Puzzle opened via interactive hotspot.")
	
	# Test 3: Incomplete submission
	puzzle_panel.min_option.selected = 0
	puzzle_panel.thida_option.selected = 0
	puzzle_panel.aung_option.selected = 0
	puzzle_panel.serve_button.pressed.emit()
	await process_frame
	assert(game_state.is_puzzle_solved("tea_order_puzzle") == false, "Incomplete submission must not solve puzzle")
	assert("haven't chosen a tea order" in puzzle_panel.feedback_label.text, "Feedback should warn about incomplete selection")
	print("✔ Test 3: Incomplete submission gracefully caught.")
	
	# Test 4: Wrong answer submission
	puzzle_panel.min_option.selected = 1 # Cho-seint (wrong for Min)
	puzzle_panel.thida_option.selected = 3 # Pawt-seint (wrong for Thida)
	puzzle_panel.aung_option.selected = 2 # Cho-pyit (wrong for Aung)
	puzzle_panel.serve_button.pressed.emit()
	await process_frame
	assert(game_state.is_puzzle_solved("tea_order_puzzle") == false, "Wrong answer must not solve puzzle")
	assert("None of the tea cups match" in puzzle_panel.feedback_label.text, "Feedback should explain wrong orders")
	print("✔ Test 4: Wrong order feedback verified.")
	
	# Test 5: Correct answer submission
	# Min = 2 (Cho-pyit), Thida = 1 (Cho-seint), Aung = 3 (Pawt-seint)
	puzzle_panel.min_option.selected = 2
	puzzle_panel.thida_option.selected = 1
	puzzle_panel.aung_option.selected = 3
	puzzle_panel.serve_button.pressed.emit()
	await process_frame
	assert(game_state.is_puzzle_solved("tea_order_puzzle") == true, "Puzzle should be solved!")
	assert("Spot on!" in puzzle_panel.feedback_label.text, "Feedback should congratulate player")
	assert(game_state.has_clue("harbor_cargo_slip") == true, "Harbor cargo slip clue must be rewarded")
	assert(puzzle_panel.status_badge.text == "STATUS: SOLVED ✔", "Status badge should show SOLVED")
	assert(puzzle_panel.serve_button.disabled == true, "Serve button should be disabled after solving")
	print("✔ Test 5: Correct submission solves puzzle and unlocks clue.")
	
	# Close puzzle
	puzzle_panel.close_puzzle()
	await process_frame
	assert(puzzle_panel.visible == false, "Puzzle should close")
	
	# Test 6: Persistence upon returning
	tea_shop.queue_free()
	await process_frame
	
	# Re-instantiate Tea Shop
	var tea_shop_2 = ts_scene.instantiate()
	root.add_child(tea_shop_2)
	await process_frame
	
	assert(game_state.is_puzzle_solved("tea_order_puzzle") == true, "Puzzle must remain solved across instances")
	var puzzle_2: TeaPuzzlePanel = tea_shop_2.get_node("%TeaPuzzlePanel")
	puzzle_2.open_puzzle()
	await process_frame
	assert(puzzle_2.status_badge.text == "STATUS: SOLVED ✔", "Re-opened puzzle must show solved state")
	assert(puzzle_2.serve_button.disabled == true, "Re-opened puzzle serve button should stay disabled")
	puzzle_2.close_puzzle()
	await process_frame
	
	# Verify Tea Master acknowledges the solved puzzle
	var tm_hotspot: InteractableHotspot = tea_shop_2.get_node("%TeaMasterHotspot")
	var dialogue_2: DialoguePanel = tea_shop_2.get_node("%DialoguePanel")
	tm_hotspot.pressed.emit()
	await process_frame
	assert(dialogue_2.visible == true, "Tea Master dialogue should open")
	assert("Table Three is happily drinking" in dialogue_2.dialogue_label.text, "Tea Master should acknowledge solved puzzle")
	dialogue_2.close_dialogue()
	await process_frame
	
	tea_shop_2.queue_free()
	await process_frame
	print("✔ Test 6: Puzzle persistence and reactive NPC dialogue verified.")
	
	game_state.set_language("my")
	print("--- ALL TEA SHOP PUZZLE TESTS PASSED ---")
	quit(0)
