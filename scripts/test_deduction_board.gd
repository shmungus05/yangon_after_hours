extends SceneTree

const Localization = preload("res://scripts/localization.gd")
const NotebookPanel = preload("res://scripts/notebook_panel.gd")

func _init() -> void:
	call_deferred("_run_tests")

func _run_tests() -> void:
	print("\n--- BEGIN INVESTIGATION BOARD & DEDUCTION SYSTEM TESTS ---")
	
	var root = get_root()
	var game_state = root.get_node_or_null("GameState")
	assert(game_state != null, "GameState autoload must exist")
	
	# Set deterministic baseline
	game_state.reset_game()
	game_state.set_language("en")
	
	# Populate test clues from tea shop mystery
	game_state.add_clue("tea_receipt_timestamp", "Late-Night Order Timestamp", "Paid at 11:42 PM", "Lucky Tea Shop")
	game_state.add_clue("tea_clock_stopped_time", "Stopped Clock at 11:45 PM", "Hands jammed at 11:45 PM", "Lucky Tea Shop")
	game_state.add_clue("tea_notebook_cipher", "Cipher in the Left-Behind Notebook", "Deliver parcel to Pier 4", "Lucky Tea Shop")
	game_state.add_clue("harbor_cargo_slip", "Stained Harbor Cargo Slip", "Pier 4 Container #7", "Lucky Tea Shop")
	game_state.add_clue("tea_port_newspaper", "Circled Port Cargo Article", "Yangon Port mysterious cargo", "Lucky Tea Shop")
	
	assert(game_state.get_clue_count() == 5, "Expected 5 clues in GameState")
	assert(game_state.get_deduction_count() == 0, "Deductions should start at 0")
	
	# Instantiate NotebookPanel
	var nb_scene: PackedScene = load("res://scenes/components/notebook_panel.tscn")
	assert(nb_scene != null, "Failed to load notebook_panel.tscn")
	var nb: NotebookPanel = nb_scene.instantiate()
	root.add_child(nb)
	await process_frame
	
	nb.open_notebook()
	assert(nb.visible == true, "Notebook must be visible after open_notebook")
	assert(nb.clue_count_label.text == "Recorded Clues: 5", "Clue count label mismatch")
	
	# Verify clue cards were generated as PanelContainers
	var card_count: int = 0
	for child in nb.clues_list.get_children():
		if child is PanelContainer:
			card_count += 1
	assert(card_count == 5, "Expected 5 clue cards in CluesList, found: " + str(card_count))
	print("✔ Test 1: NotebookPanel instantiation and 5 visual clue cards verified.")
	
	# =========================================================================
	# TEST 2: Tab Switching
	# =========================================================================
	assert(nb._active_tab == "clues", "Initial tab should be 'clues'")
	assert(nb.clues_view.visible == true, "CluesView should be visible")
	assert(nb.deductions_view.visible == false, "DeductionsView should start hidden")
	
	nb.deductions_tab_btn.pressed.emit()
	assert(nb._active_tab == "deductions", "Active tab should switch to 'deductions'")
	assert(nb.clues_view.visible == false, "CluesView should hide")
	assert(nb.deductions_view.visible == true, "DeductionsView should show")
	assert(nb.deductions_empty_label.visible == true, "Empty deductions label should be visible")
	
	nb.clues_tab_btn.pressed.emit()
	assert(nb._active_tab == "clues", "Active tab should switch back to 'clues'")
	assert(nb.clues_view.visible == true, "CluesView should be visible again")
	print("✔ Test 2: Tab navigation (Evidence & Deductions) verified.")
	
	# =========================================================================
	# TEST 3: Clue Selection and Slot Workbench
	# =========================================================================
	# Select clue 1: receipt
	nb.toggle_clue_selection("tea_receipt_timestamp")
	assert(nb._selected_clue_ids.size() == 1, "Should have 1 selected clue")
	assert("Receipt" in nb.slot1_button.text or "Timestamp" in nb.slot1_button.text, "Slot 1 text mismatch")
	assert(nb.deduce_button.disabled == true, "Deduce button should be disabled with only 1 clue")
	
	# Select clue 2: clock
	nb.toggle_clue_selection("tea_clock_stopped_time")
	assert(nb._selected_clue_ids.size() == 2, "Should have 2 selected clues")
	assert("Clock" in nb.slot2_button.text or "11:45" in nb.slot2_button.text, "Slot 2 text mismatch")
	assert(nb.deduce_button.disabled == false, "Deduce button should be enabled with 2 clues")
	
	# Deselect slot 2
	nb.slot2_button.pressed.emit()
	assert(nb._selected_clue_ids.size() == 1, "Should have 1 clue after removing slot 2")
	assert(nb.deduce_button.disabled == true, "Deduce button should disable again")
	
	# Clear selection
	nb.clear_button.pressed.emit()
	assert(nb._selected_clue_ids.is_empty(), "Selection should be empty after clear")
	print("✔ Test 3: Clue selection, workbench slot binding, and clear button verified.")
	
	# =========================================================================
	# TEST 4: Invalid Clue Combination (No Penalty)
	# =========================================================================
	# Connect receipt + newspaper (no direct deduction)
	nb.toggle_clue_selection("tea_receipt_timestamp")
	nb.toggle_clue_selection("tea_port_newspaper")
	assert(nb._selected_clue_ids.size() == 2, "2 clues selected")
	
	var mismatch_res = nb.attempt_connection()
	assert(mismatch_res.get("status") == "NO_CONNECTION", "Expected NO_CONNECTION for mismatch")
	assert(game_state.get_deduction_count() == 0, "No deduction should be unlocked for mismatch")
	assert(nb.feedback_label.text.length() > 0, "Feedback text must be shown to player")
	print("✔ Test 4: Invalid clue combination gives helpful feedback without penalty.")
	
	# =========================================================================
	# TEST 5: Valid Deduction 1 (Timeline: Receipt + Stopped Clock)
	# =========================================================================
	nb.clear_selection()
	nb.toggle_clue_selection("tea_receipt_timestamp")
	nb.toggle_clue_selection("tea_clock_stopped_time")
	
	var match1_res = nb.attempt_connection()
	assert(match1_res.get("status") == "SUCCESS", "Expected SUCCESS for receipt + clock")
	assert(game_state.has_deduction("deduction_tea_three_minutes") == true, "Must have deduction_tea_three_minutes")
	assert(game_state.get_deduction_count() == 1, "Expected 1 deduction")
	assert("Three-Minute" in nb.feedback_label.text, "Feedback should mention deduction title")
	
	# Verify deduction card rendered in Deductions tab
	nb.deductions_tab_btn.pressed.emit()
	assert(nb.deductions_empty_label.visible == false, "Empty state should be hidden after first deduction")
	var ded_card_count: int = 0
	for child in nb.deductions_list.get_children():
		if child is PanelContainer:
			ded_card_count += 1
	assert(ded_card_count == 1, "Expected 1 deduction card in DeductionsList, found: " + str(ded_card_count))
	print("✔ Test 5: Valid Deduction 1 (Three-Minute Rush) successfully synthesized and rendered.")
	
	# =========================================================================
	# TEST 6: Duplicate Deduction Prevention
	# =========================================================================
	nb.clues_tab_btn.pressed.emit()
	nb.toggle_clue_selection("tea_receipt_timestamp")
	nb.toggle_clue_selection("tea_clock_stopped_time")
	var dup_res = nb.attempt_connection()
	assert(dup_res.get("status") == "ALREADY_UNLOCKED", "Expected ALREADY_UNLOCKED")
	assert(game_state.get_deduction_count() == 1, "Deduction count must not increase on duplicate")
	print("✔ Test 6: Duplicate deduction correctly identified and prevented.")
	
	# =========================================================================
	# TEST 7: Order Independence & Valid Deduction 2 (Rendezvous: Slip + Cipher)
	# =========================================================================
	# Test reverse order: harbor_cargo_slip first, tea_notebook_cipher second
	nb.clear_selection()
	nb.toggle_clue_selection("harbor_cargo_slip")
	nb.toggle_clue_selection("tea_notebook_cipher")
	var match2_res = nb.attempt_connection()
	assert(match2_res.get("status") == "SUCCESS", "Reverse order connection must succeed")
	assert(game_state.has_deduction("deduction_tea_pier_rendezvous") == true, "Must have deduction_tea_pier_rendezvous")
	assert(game_state.get_deduction_count() == 2, "Expected 2 deductions")
	print("✔ Test 7: Valid Deduction 2 with reverse clue order verified.")
	
	# =========================================================================
	# TEST 8: Valid Deduction 3 (Smuggling Syndicate: Newspaper + Slip)
	# =========================================================================
	nb.clear_selection()
	nb.toggle_clue_selection("tea_port_newspaper")
	nb.toggle_clue_selection("harbor_cargo_slip")
	var match3_res = nb.attempt_connection()
	assert(match3_res.get("status") == "SUCCESS", "Expected SUCCESS for newspaper + slip")
	assert(game_state.has_deduction("deduction_tea_smuggling_ring") == true, "Must have deduction_tea_smuggling_ring")
	assert(game_state.get_deduction_count() == 3, "Expected 3 deductions")
	print("✔ Test 8: Valid Deduction 3 (Covert Midnight Smuggling Ring) verified.")
	
	# =========================================================================
	# TEST 9: Bilingual Localization (Myanmar & English)
	# =========================================================================
	game_state.set_language("my")
	nb.refresh_clues()
	nb.refresh_deductions()
	
	assert("စုံစမ်းစစ်ဆေးရေး" in nb.title_label.text, "Title should be localized in Burmese")
	assert("သဲလွန်စများ" in nb.clues_tab_btn.text, "Clues tab button should be localized in Burmese")
	assert("ကောက်ချက်ချမှုများ" in nb.deductions_tab_btn.text, "Deductions tab button should be localized in Burmese")
	
	# Check localized deduction in Burmese
	var burmese_deds = game_state.get_deductions()
	assert(burmese_deds.size() == 3, "Expected 3 localized deductions")
	assert("သုံးမိနစ်" in burmese_deds[0]["title"], "Deduction title should be localized in Burmese")
	
	# Switch back to English
	game_state.set_language("en")
	nb.refresh_clues()
	nb.refresh_deductions()
	assert("INVESTIGATION BOARD" in nb.title_label.text, "Title should return to English")
	print("✔ Test 9: Bilingual display for notebook board and deductions verified.")
	
	nb.close_notebook()
	assert(nb.visible == false, "Notebook should be hidden after close_notebook")
	nb.queue_free()
	await process_frame
	
	print("--- ALL INVESTIGATION BOARD & DEDUCTION SYSTEM TESTS PASSED ---")
	quit(0)
