extends SceneTree

## Automated test suite for Market Notebook Puzzle, Final Delivery Puzzle, and Game Ending.

func _init() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN MARKET NOTEBOOK & DELIVERY PUZZLE TESTS ---")
	
	var game_state = root.get_node_or_null("GameState")
	if not game_state:
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.set_script(gs_script)
		game_state.name = "GameState"
		root.add_child(game_state)
	
	game_state.reset_game()
	game_state.set_language("en")
	
	# =========================================================================
	# TEST 1: Market Scene Hotspots & Initial Dialogue
	# =========================================================================
	var market_packed = load("res://scenes/locations/market.tscn")
	var market_scene = market_packed.instantiate()
	root.add_child(market_scene)
	await process_frame
	
	var vendor_hotspot: InteractableHotspot = market_scene.get_node("MarginContainer/MainLayout/HotspotArea/VendorHotspot")
	var chest_hotspot: InteractableHotspot = market_scene.get_node("MarginContainer/MainLayout/HotspotArea/MarketNotebookHotspot")
	var market_puzzle: MarketPuzzlePanel = market_scene.get_node("MarketPuzzlePanel")
	
	assert(vendor_hotspot != null, "VendorHotspot must exist in Market")
	assert(chest_hotspot != null, "MarketNotebookHotspot must exist in Market")
	assert(market_puzzle != null, "MarketPuzzlePanel must exist in Market")
	print("✔ Test 1: Market scene nodes and puzzle panel instantiated successfully.")
	
	# =========================================================================
	# TEST 2: Open Market Puzzle via Hotspot
	# =========================================================================
	assert(not market_puzzle.visible, "Market puzzle should be hidden initially")
	chest_hotspot.interact()
	await process_frame
	assert(market_puzzle.visible, "Clicking MarketNotebookHotspot must open MarketPuzzlePanel")
	print("✔ Test 2: MarketNotebookHotspot opens MarketPuzzlePanel.")
	
	# =========================================================================
	# TEST 3: Incomplete Combination Submission
	# =========================================================================
	market_puzzle.emblem_option.selected = 0
	market_puzzle.stash_option.selected = 1
	market_puzzle.spice_option.selected = 1
	market_puzzle._on_unlock_pressed()
	
	assert(not game_state.is_puzzle_solved("market_notebook_puzzle"), "Incomplete combination must not solve puzzle")
	assert("must set all three" in market_puzzle.feedback_label.text, "Feedback must warn about unselected dials")
	print("✔ Test 3: Incomplete combination correctly caught.")
	
	# =========================================================================
	# TEST 4: Wrong Combination Submission
	# =========================================================================
	market_puzzle.emblem_option.selected = 2 # Wrong emblem
	market_puzzle.stash_option.selected = 1  # Correct stash
	market_puzzle.spice_option.selected = 1  # Correct spice
	market_puzzle._on_unlock_pressed()
	
	assert(not game_state.is_puzzle_solved("market_notebook_puzzle"), "Wrong combination must not solve puzzle")
	assert("❌" in market_puzzle.feedback_label.text, "Feedback must indicate failure")
	print("✔ Test 4: Wrong combination correctly rejected with hint.")
	
	# =========================================================================
	# TEST 5: Correct Combination Submission & Clue Unlock
	# =========================================================================
	market_puzzle.emblem_option.selected = 1 # Royal Burmese Peacock Seal
	market_puzzle.stash_option.selected = 1  # Pier 4 Riverboat Cargo Stash
	market_puzzle.spice_option.selected = 1  # Shan Star Anise & Dried Chili
	market_puzzle._on_unlock_pressed()
	
	assert(game_state.is_puzzle_solved("market_notebook_puzzle"), "Correct combination must mark puzzle solved")
	assert(game_state.has_clue("vendor_delivery_ledger"), "Solving puzzle must record vendor_delivery_ledger clue")
	assert("UNLOCKED" in market_puzzle.status_badge.text, "Status badge must update to UNLOCKED")
	print("✔ Test 5: Market Notebook Puzzle solved and vendor ledger clue recorded.")
	
	# =========================================================================
	# TEST 6: Reactive NPC Dialogue after Market Puzzle Solved
	# =========================================================================
	vendor_hotspot.interact()
	var dialogue_panel = market_scene.get_node("DialoguePanel")
	assert(dialogue_panel.visible, "DialoguePanel should open on vendor interaction")
	assert("Passcode 1886" in dialogue_panel.dialogue_label.text or "saved my grandfather" in dialogue_panel.dialogue_label.text, "Vendor dialogue must react to recovered notebook")
	dialogue_panel.close_dialogue()
	print("✔ Test 6: Vendor Ko Lin provides dynamic reactive dialogue with recovered notebook.")
	
	market_scene.queue_free()
	
	# =========================================================================
	# TEST 7: Downtown Final Delivery Puzzle Setup
	# =========================================================================
	var downtown_packed = load("res://scenes/locations/downtown.tscn")
	var downtown_scene = downtown_packed.instantiate()
	root.add_child(downtown_scene)
	await process_frame
	
	var delivery_hotspot: InteractableHotspot = downtown_scene.get_node("MarginContainer/MainLayout/HotspotArea/DeliveryHotspot")
	var delivery_puzzle: DeliveryPuzzlePanel = downtown_scene.get_node("DeliveryPuzzlePanel")
	var watchman_hotspot: InteractableHotspot = downtown_scene.get_node("MarginContainer/MainLayout/HotspotArea/WatchmanHotspot")
	
	assert(delivery_hotspot != null, "DeliveryHotspot must exist in Downtown")
	assert(delivery_puzzle != null, "DeliveryPuzzlePanel must exist in Downtown")
	
	# Open Delivery Puzzle
	delivery_hotspot.interact()
	await process_frame
	assert(delivery_puzzle.visible, "Clicking DeliveryHotspot must open DeliveryPuzzlePanel")
	print("✔ Test 7: Downtown DeliveryHotspot opens DeliveryPuzzlePanel.")
	
	# =========================================================================
	# TEST 8: Delivery Verification Logic
	# =========================================================================
	# Wrong verification
	delivery_puzzle.seal_option.selected = 2
	delivery_puzzle.passcode_option.selected = 1
	delivery_puzzle.recipient_option.selected = 1
	delivery_puzzle._on_deliver_pressed()
	
	assert(not game_state.is_puzzle_solved("final_delivery_puzzle"), "Invalid credentials must not complete delivery")
	
	# Correct verification: Hintha Bird Seal (1), Passcode 1886 (2), Watchman U Ba (1)
	delivery_puzzle.seal_option.selected = 1
	delivery_puzzle.passcode_option.selected = 2
	delivery_puzzle.recipient_option.selected = 1
	delivery_puzzle._on_deliver_pressed()
	
	assert(game_state.is_puzzle_solved("final_delivery_puzzle"), "Valid credentials must solve final_delivery_puzzle")
	assert(game_state.has_clue("heritage_vault_secured"), "Solving delivery puzzle must record heritage_vault_secured clue")
	assert(game_state.is_game_completed(), "is_game_completed() must return true")
	assert(delivery_puzzle.ending_button.visible, "Ending button must become visible on completion")
	print("✔ Test 8: Final Delivery Puzzle solved, heritage relics secured, game completed.")
	
	# =========================================================================
	# TEST 9: Game Ending Screen Verification
	# =========================================================================
	game_state.mark_puzzle_solved("tea_order_puzzle")
	var ending_packed = load("res://scenes/game_ending.tscn")
	var ending_scene = ending_packed.instantiate()
	root.add_child(ending_scene)
	await process_frame
	
	var ending_script = ending_scene.get_node(".")
	assert(ending_script != null, "GameEnding scene must instantiate")
	assert("3 / 3" in ending_scene.puzzle_stat_label.text, "Puzzle stats must show 3 / 3 completed")
	
	# Test restart game
	ending_scene._on_restart_pressed()
	assert(game_state.get_clue_count() == 0, "Restarting game must reset clues")
	assert(game_state.get_solved_puzzle_count() == 0, "Restarting game must reset puzzles")
	print("✔ Test 9: Game Ending screen displays accurate stats and cleanly resets game.")
	
	downtown_scene.queue_free()
	ending_scene.queue_free()
	
	game_state.set_language("my")
	print("--- ALL MARKET & DELIVERY PUZZLE TESTS PASSED ---")
	quit(0)
