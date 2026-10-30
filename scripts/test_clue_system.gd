extends SceneTree

func _initialize() -> void:
	_run_tests()

func _run_tests() -> void:
	print("--- BEGIN CLUE SYSTEM & NOTEBOOK TESTS ---")
	
	var game_state = root.get_node_or_null("GameState")
	if game_state == null:
		# If running standalone, load and instantiate GameState
		var gs_script = load("res://scripts/game_state.gd")
		game_state = Node.new()
		game_state.set_script(gs_script)
		game_state.name = "GameState"
		root.add_child(game_state)
		await process_frame
	
	game_state.set_language("en")
	game_state.clear_clues()
	assert(game_state.get_clue_count() == 0, "Initial clue count should be 0")
	
	# Test 1: Deduplication & Recording
	var added_1: bool = game_state.add_clue("clue_1", "Test Clue 1", "Desc 1", "Downtown")
	assert(added_1 == true, "First clue addition should return true")
	assert(game_state.get_clue_count() == 1, "Clue count should be 1")
	assert(game_state.has_clue("clue_1") == true, "GameState should have clue_1")
	
	var added_dup: bool = game_state.add_clue("clue_1", "Test Clue 1", "Desc 1", "Downtown")
	assert(added_dup == false, "Duplicate clue addition should return false")
	assert(game_state.get_clue_count() == 1, "Clue count should remain 1 after duplicate")
	
	var added_2: bool = game_state.add_clue("clue_2", "Test Clue 2", "Desc 2", "Tea Shop")
	assert(added_2 == true, "Second unique clue should return true")
	assert(game_state.get_clue_count() == 2, "Clue count should be 2")
	print("✔ Test 1: GameState clue recording and duplicate prevention passed.")
	
	# Test 2: NotebookPanel Component
	var nb_scene: PackedScene = load("res://scenes/components/notebook_panel.tscn")
	assert(nb_scene != null, "NotebookPanel scene failed to load")
	var nb: NotebookPanel = nb_scene.instantiate()
	root.add_child(nb)
	await process_frame
	
	assert(nb.visible == false, "Notebook should start hidden")
	nb.open_notebook()
	assert(nb.visible == true, "Notebook should be visible after open_notebook()")
	assert(nb.clue_count_label.text == "Recorded Clues: 2", "Clue count label mismatch")
	
	# Count generated cards (excluding empty state label)
	var card_count: int = 0
	for child in nb.clues_list.get_children():
		if child is PanelContainer:
			card_count += 1
	assert(card_count == 2, "Expected 2 clue cards in notebook, found: " + str(card_count))
	
	nb.close_notebook()
	assert(nb.visible == false, "Notebook should be hidden after close_notebook()")
	nb.queue_free()
	await process_frame
	print("✔ Test 2: NotebookPanel UI rendering and open/close passed.")
	
	# Test 3: Location Scene Hotspots & Multi-Click Verification
	game_state.clear_clues()
	var downtown_scene: PackedScene = load("res://scenes/locations/downtown.tscn")
	var downtown = downtown_scene.instantiate()
	root.add_child(downtown)
	await process_frame
	
	var notice_board: InteractableHotspot = downtown.get_node("%NoticeBoardHotspot")
	var dt_dialogue: DialoguePanel = downtown.get_node("%DialoguePanel")
	var dt_notebook: NotebookPanel = downtown.get_node("%NotebookPanel")
	var dt_nb_btn: Button = downtown.get_node("%NotebookButton")
	
	# Click 1: First inspection
	notice_board.pressed.emit()
	await process_frame
	assert(dt_dialogue.visible == true, "Dialogue should open on first click")
	assert(game_state.has_clue("downtown_pier_note") == true, "Clue should be recorded on inspection")
	assert(game_state.get_clue_count() == 1, "Clue count should be 1")
	assert(dt_nb_btn.text == "📓 Notebook (1)", "Notebook button label should update to (1)")
	
	# Close dialogue
	dt_dialogue.close_dialogue()
	await process_frame
	assert(dt_dialogue.visible == false, "Dialogue should be closed")
	
	# Click 2: Second inspection (verifying user bug fix!)
	notice_board.pressed.emit()
	await process_frame
	assert(dt_dialogue.visible == true, "Dialogue MUST open on subsequent clicks!")
	assert(game_state.get_clue_count() == 1, "Clue count should not duplicate on second click")
	
	dt_dialogue.close_dialogue()
	await process_frame
	
	# Open notebook in downtown
	dt_nb_btn.pressed.emit()
	await process_frame
	assert(dt_notebook.visible == true, "Notebook should open via NotebookButton")
	dt_notebook.close_notebook()
	await process_frame
	assert(dt_notebook.visible == false, "Notebook should close cleanly")
	
	downtown.queue_free()
	await process_frame
	print("✔ Test 3: Downtown hotspot, clue recording, and multi-click verification passed.")
	
	# Test 4: Persistence across scene transition (Tea Shop)
	assert(game_state.get_clue_count() == 1, "Clue must persist after leaving Downtown")
	var tea_shop_scene: PackedScene = load("res://scenes/locations/tea_shop.tscn")
	var tea_shop = tea_shop_scene.instantiate()
	root.add_child(tea_shop)
	await process_frame
	
	var ts_nb_btn: Button = tea_shop.get_node("%NotebookButton")
	assert(ts_nb_btn.text == "📓 Notebook (1)", "Tea Shop notebook button should reflect existing clue count (1)")
	
	var table_hotspot: InteractableHotspot = tea_shop.get_node("%TableHotspot")
	var ts_dialogue: DialoguePanel = tea_shop.get_node("%DialoguePanel")
	
	# Click table hotspot in tea shop
	table_hotspot.pressed.emit()
	await process_frame
	assert(ts_dialogue.visible == true, "Tea shop dialogue should open")
	assert(game_state.get_clue_count() == 2, "Total clues should now be 2")
	assert(ts_nb_btn.text == "📓 Notebook (2)", "Notebook button should now show (2)")
	
	# Multi-click on Tea Shop hotspot
	ts_dialogue.close_dialogue()
	await process_frame
	table_hotspot.pressed.emit()
	await process_frame
	assert(ts_dialogue.visible == true, "Tea shop dialogue must open on second click")
	ts_dialogue.close_dialogue()
	await process_frame
	
	# Open notebook in Tea Shop and verify both Downtown and Tea Shop clues are present
	var ts_notebook: NotebookPanel = tea_shop.get_node("%NotebookPanel")
	ts_nb_btn.pressed.emit()
	await process_frame
	assert(ts_notebook.visible == true, "Notebook should open in Tea Shop")
	assert(ts_notebook.clue_count_label.text == "Recorded Clues: 2", "Notebook should show 2 persistent clues")
	ts_notebook.close_notebook()
	await process_frame
	
	tea_shop.queue_free()
	await process_frame
	print("✔ Test 4: Cross-location clue persistence and multi-click in Tea Shop passed.")
	
	game_state.set_language("my")
	print("--- ALL CLUE SYSTEM & NOTEBOOK TESTS PASSED ---")
	quit(0)
