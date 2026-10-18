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

	var ludus_scene := load("res://scenes/ludus.tscn").instantiate() as Control
	root.add_child(ludus_scene)
	await process_frame

	var first_candidate_button := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/SelectButton"
	) as Button
	first_candidate_button.pressed.emit()
	_check(state.has_selected_starting_candidate, "seleção inicial libera o lobby")

	var recruitment_plate := ludus_scene.get_node("HubPlates/RecruitmentPlate") as Button
	_check(recruitment_plate.visible, "placa de contratação aparece com vagas livres")
	recruitment_plate.pressed.emit()
	_check(
		ludus_scene.get_node("CenterContainer/RosterPanel/Content/Title").text
		== "Contratar gladiadores",
		"placa abre o painel de contratação"
	)
	_check(state.recruitment_offers.size() == 2, "gera uma oferta para cada vaga vazia")
	if state.recruitment_offers.size() != 2:
		quit(1)
		return

	var offers_snapshot: Array = state.recruitment_offers.duplicate(true)
	var initial_candidate_names: Array[String] = []
	var portrait_ids: Array[int] = []
	for candidate in state.starting_candidates:
		initial_candidate_names.append(candidate["name"])
		portrait_ids.append(candidate["portrait_id"])
	for offer in offers_snapshot:
		_check(
			not initial_candidate_names.has(offer["name"]),
			"oferta de contratação é diferente das ofertas iniciais"
		)
		_check(
			typeof(offer["sword_proficiency"]) == TYPE_INT
			and offer["sword_proficiency"] >= 0
			and offer["sword_proficiency"] <= 100
			and typeof(offer["spear_proficiency"]) == TYPE_INT
			and offer["spear_proficiency"] >= 0
			and offer["spear_proficiency"] <= 100,
			"oferta mostra proficiências inteiras entre 0 e 100"
		)
		_check(
			offer["portrait_id"] >= 1
			and offer["portrait_id"] <= 25
			and not portrait_ids.has(offer["portrait_id"]),
			"oferta recebe retrato válido e não repetido na sessão"
		)
		portrait_ids.append(offer["portrait_id"])
	for offer_card in ["First", "Second"]:
		var offer_status := ludus_scene.get_node(
			"CenterContainer/RosterPanel/Content/Roster/%sCombatantCard/Content/Status"
			% offer_card
		) as Label
		_check(
			offer_status.text.contains("Espada:")
			and offer_status.text.contains("Lança:")
			and offer_status.text.contains("/100"),
			"cartão de contratação %s exibe as proficiências 0–100" % offer_card
		)

	var market_info := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/RecruitmentInfoLabel"
	) as Label
	_check(
		market_info.text.contains("100 moedas")
		and market_info.text.contains("30 moedas"),
		"painel informa saldo e custo provisório"
	)

	var offer_button := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/SelectButton"
	) as Button
	var offer_portrait := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/Portrait"
	) as TextureRect
	_check(
		offer_portrait.visible
		and offer_portrait.texture != null
		and offer_portrait.texture.resource_path == _portrait_path(offers_snapshot[0]["portrait_id"]),
		"cartão de contratação mostra o retrato associado à oferta"
	)
	_check(offer_button.text.contains("30 moedas"), "botão informa o preço da oferta")
	offer_button.pressed.emit()
	_check(state.coins == 70, "compra desconta o custo uma vez")
	_check(
		state.get_roster_slot("Gladiador 2").get("candidate", {}).get("name", "")
		== offers_snapshot[0]["name"],
		"contratação ocupa a próxima vaga livre"
	)
	_check(
		state.get_roster_slot("Gladiador 2").get("candidate", {}).get("portrait_id", -1)
		== offers_snapshot[0]["portrait_id"],
		"gladiador contratado mantém o retrato da oferta"
	)
	_check(
		state.get_roster_slot("Gladiador 3").get("candidate", {}).is_empty(),
		"a vaga seguinte permanece vazia"
	)
	_check(
		_same_offer_profiles(state.recruitment_offers, offers_snapshot),
		"ofertas permanecem estáveis depois da contratação"
	)
	_check(
		state.recruitment_offers[0].get("is_purchased", false),
		"oferta comprada fica marcada como indisponível"
	)

	ludus_scene.queue_free()
	await process_frame
	ludus_scene = load("res://scenes/ludus.tscn").instantiate() as Control
	root.add_child(ludus_scene)
	await process_frame

	recruitment_plate = ludus_scene.get_node("HubPlates/RecruitmentPlate") as Button
	_check(recruitment_plate.visible, "lobby reaberto mantém vaga livre")
	recruitment_plate.pressed.emit()
	_check(
		_same_offer_profiles(state.recruitment_offers, offers_snapshot),
		"trocar de cena mantém as mesmas ofertas"
	)
	_check(
		state.get_roster_slot("Gladiador 2").get("candidate", {}).get("name", "")
		== offers_snapshot[0]["name"],
		"trocar de cena mantém a contratação no elenco"
	)
	offer_portrait = ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/Portrait"
	) as TextureRect
	_check(
		offer_portrait.visible
		and offer_portrait.texture != null
		and offer_portrait.texture.resource_path
		== _portrait_path(offers_snapshot[0]["portrait_id"]),
		"trocar de cena mantém retrato na oferta"
	)
	offer_button = ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/SelectButton"
	) as Button
	_check(offer_button.disabled, "oferta já comprada não pode ser comprada novamente")

	state.coins = 20
	ludus_scene.call("_refresh_recruitment_panel")
	var second_offer_button := ludus_scene.get_node(
		"CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/SelectButton"
	) as Button
	_check(second_offer_button.disabled, "saldo insuficiente bloqueia a contratação")
	second_offer_button.pressed.emit()
	_check(state.coins == 20, "tentativa sem saldo não cobra moedas")
	_check(
		state.get_roster_slot("Gladiador 3").get("candidate", {}).is_empty(),
		"tentativa sem saldo não ocupa vaga"
	)

	state.coins = LudusState.RECRUITMENT_COST
	ludus_scene.call("_refresh_recruitment_panel")
	second_offer_button.pressed.emit()
	_check(state.coins == 0, "segunda contratação cobra o custo provisório")
	_check(
		state.get_roster_slot("Gladiador 3").get("candidate", {}).get("name", "")
		== offers_snapshot[1]["name"],
		"segunda contratação ocupa a última vaga"
	)
	_check(not recruitment_plate.visible, "placa some quando o elenco fica completo")
	_check(
		not state.purchase_recruitment_offer(1),
		"oferta já comprada não pode ser contratada novamente"
	)

	ludus_scene.queue_free()
	await process_frame

	if failures == 0:
		print("LUDUS-006: todos os testes focados passaram.")
		quit(0)
	else:
		push_error("LUDUS-006: %d teste(s) focado(s) falharam." % failures)
		quit(1)


func _check(condition: bool, description: String) -> void:
	if condition:
		return
	failures += 1
	push_error("Falha no teste focado: %s" % description)


func _same_offer_profiles(actual: Array[Dictionary], expected: Array) -> bool:
	if actual.size() != expected.size():
		return false
	for offer_index in range(actual.size()):
		for profile_key in ["name", "sword_proficiency", "spear_proficiency", "portrait_id"]:
			if actual[offer_index].get(profile_key) != expected[offer_index].get(profile_key):
				return false
	return true


func _portrait_path(portrait_id: int) -> String:
	return "res://art/portraits/Pixel_art_Portrait_%d.png" % portrait_id
