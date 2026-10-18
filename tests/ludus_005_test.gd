extends SceneTree

var failures: int = 0


func _initialize() -> void:
	call_deferred("_run_tests")


func _run_tests() -> void:
	var state: Variant = root.get_node_or_null("LudusState")
	_check(state != null, "autoload LudusState carregado")
	if state == null:
		quit(1)
		return

	_check(state.starting_candidates.size() == 3, "gera exatamente três candidatos")
	if state.starting_candidates.size() != 3:
		quit(1)
		return
	var offers_snapshot: Array = state.starting_candidates.duplicate(true)
	for candidate in offers_snapshot:
		for proficiency_key in ["sword_proficiency", "spear_proficiency"]:
			var proficiency: Variant = candidate.get(proficiency_key)
			_check(
				typeof(proficiency) == TYPE_INT and proficiency >= 1 and proficiency <= 5,
				"%s é inteiro entre 1 e 5" % proficiency_key
			)

	_check(state.roster.size() == 3, "elenco oferece exatamente três vagas")
	_check(not state.has_selected_starting_candidate, "sessão inicia sem escolha automática")
	_check(not state.select_combatant("Gladiador 1"), "vaga não pode ser selecionada antes da escolha")
	_check(
		not state.accept_contract(LudusState.ContractType.INDIVIDUAL),
		"contrato não pode ser aceito antes da escolha"
	)

	var ludus_scene := load("res://scenes/ludus.tscn").instantiate() as Control
	root.add_child(ludus_scene)
	await process_frame
	var hub_plates := ludus_scene.get_node("HubPlates") as Control
	var initial_panel := ludus_scene.get_node("CenterContainer") as Control
	_check(not hub_plates.visible, "hub fica bloqueado antes da escolha")
	_check(initial_panel.visible, "tela inicial de escolha é exibida")
	for candidate_card in ["First", "Second", "Third"]:
		var candidate_button := ludus_scene.get_node(
			"CenterContainer/RosterPanel/Content/Roster/%sCombatantCard/Content/SelectButton"
			% candidate_card
		) as Button
		var candidate_status := ludus_scene.get_node(
			"CenterContainer/RosterPanel/Content/Roster/%sCombatantCard/Content/Status"
			% candidate_card
		) as Label
		_check(candidate_button.visible, "cartão %s oferece uma escolha" % candidate_card)
		_check(
			candidate_status.text.contains("Espada:")
			and candidate_status.text.contains("Lança:"),
			"oferta %s mostra as duas proficiências" % candidate_card
		)

	var second_candidate_button := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/SelectButton"
	) as Button
	var coins_before_choice: int = state.coins
	second_candidate_button.pressed.emit()
	_check(state.has_selected_starting_candidate, "escolha inicial é registrada")
	_check(hub_plates.visible, "escolha abre o hub")
	_check(not initial_panel.visible, "tela obrigatória fecha após escolha")
	_check(
		state.get_roster_slot("Gladiador 1").get("candidate", {}) == offers_snapshot[1],
		"candidato escolhido ocupa a vaga Gladiador 1"
	)
	_check(state.coins == coins_before_choice, "escolha inicial não cobra moedas")
	_check(
		state.get_roster_slot("Gladiador 2").get("candidate", {}).is_empty(),
		"vaga Gladiador 2 começa vazia"
	)
	_check(
		state.get_roster_slot("Gladiador 3").get("candidate", {}).is_empty(),
		"vaga Gladiador 3 começa vazia"
	)
	_check(
		not state.select_starting_candidate(0),
		"não há troca/refresh das ofertas após a escolha inicial"
	)

	_check(
		state.accept_contract(LudusState.ContractType.INDIVIDUAL),
		"contrato individual permanece disponível"
	)
	_check(
		state.get_contract_state(LudusState.ContractType.INDIVIDUAL).get(
			"linked_gladiator", ""
		) == "Gladiador 1",
		"contrato guarda ID da vaga, não nome do candidato"
	)
	var roster_plate := ludus_scene.get_node("HubPlates/RosterPlate") as Button
	roster_plate.pressed.emit()
	var back_button := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/BackButton"
	) as Button
	var first_roster_status := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/Status"
	) as Label
	var second_roster_status := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/Status"
	) as Label
	var third_roster_status := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/ThirdCombatantCard/Content/Status"
	) as Label
	_check(back_button.visible, "painel de elenco mantém ação para voltar ao hub")
	_check(
		first_roster_status.text.contains("Escravo 2"),
		"painel de elenco mostra o candidato escolhido"
	)
	_check(second_roster_status.text == "Vaga vazia", "painel mostra a segunda vaga vazia")
	_check(third_roster_status.text == "Vaga vazia", "painel mostra a terceira vaga vazia")
	back_button.pressed.emit()
	_check(hub_plates.visible, "botão voltar retorna ao hub após a escolha inicial")

	ludus_scene.queue_free()
	await process_frame
	var arena_scene: Node = load("res://scenes/arena.tscn").instantiate()
	root.add_child(arena_scene)
	await process_frame
	_check(
		state.starting_candidates == offers_snapshot,
		"ofertas permanecem estáveis ao trocar para a arena"
	)
	arena_scene.queue_free()
	await process_frame
	var reopened_ludus := load("res://scenes/ludus.tscn").instantiate() as Control
	root.add_child(reopened_ludus)
	await process_frame
	var reopened_hub := reopened_ludus.get_node("HubPlates") as Control
	var reopened_panel := reopened_ludus.get_node("CenterContainer") as Control
	_check(
		reopened_hub.visible and not reopened_panel.visible,
		"ao retornar à cena, o hub continua liberado"
	)
	_check(
		state.starting_candidates == offers_snapshot,
		"ofertas continuam iguais após retornar ao Ludus"
	)

	if failures == 0:
		print("LUDUS-005: todos os testes focados passaram.")
		quit(0)
	else:
		push_error("LUDUS-005: %d teste(s) focado(s) falharam." % failures)
		quit(1)


func _check(condition: bool, description: String) -> void:
	if condition:
		return
	failures += 1
	push_error("Falha no teste focado: %s" % description)
