extends Control

const ARENA_SCENE: String = "res://scenes/arena.tscn"

@onready var first_combatant_button: Button = $CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/SelectButton
@onready var second_combatant_button: Button = $CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/SelectButton
@onready var third_combatant_button: Button = $CenterContainer/RosterPanel/Content/Roster/ThirdCombatantCard/Content/SelectButton
@onready var first_combatant_name: Label = $CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/Name
@onready var second_combatant_name: Label = $CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/Name
@onready var third_combatant_name: Label = $CenterContainer/RosterPanel/Content/Roster/ThirdCombatantCard/Content/Name
@onready var first_combatant_status: Label = $CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/Status
@onready var second_combatant_status: Label = $CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/Status
@onready var third_combatant_status: Label = $CenterContainer/RosterPanel/Content/Roster/ThirdCombatantCard/Content/Status
@onready var first_combatant_portrait: TextureRect = $CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/Portrait
@onready var second_combatant_portrait: TextureRect = $CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/Portrait
@onready var third_combatant_portrait: TextureRect = $CenterContainer/RosterPanel/Content/Roster/ThirdCombatantCard/Content/Portrait
@onready var first_combatant_card: PanelContainer = $CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard
@onready var second_combatant_card: PanelContainer = $CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard
@onready var third_combatant_card: PanelContainer = $CenterContainer/RosterPanel/Content/Roster/ThirdCombatantCard
@onready var subtitle_label: Label = $CenterContainer/RosterPanel/Content/Subtitle
@onready var description_label: Label = $CenterContainer/RosterPanel/Content/Description
@onready var recruitment_info_label: Label = $CenterContainer/RosterPanel/Content/RecruitmentInfoLabel
@onready var roster_container: HBoxContainer = $CenterContainer/RosterPanel/Content/Roster
@onready var selection_label: Label = $CenterContainer/RosterPanel/Content/SelectionLabel
@onready var equipment_heading: Label = $CenterContainer/RosterPanel/Content/EquipmentHeading
@onready var equipment_options: HBoxContainer = $CenterContainer/RosterPanel/Content/EquipmentOptions
@onready var sword_button: Button = $CenterContainer/RosterPanel/Content/EquipmentOptions/SwordButton
@onready var spear_button: Button = $CenterContainer/RosterPanel/Content/EquipmentOptions/SpearButton
@onready var weapon_selection_label: Label = $CenterContainer/RosterPanel/Content/WeaponSelectionLabel
@onready var last_combat_result_label: Label = $CenterContainer/RosterPanel/Content/LastCombatResultLabel
@onready var balance_label: Label = $CenterContainer/RosterPanel/Content/WalletPanel/BalanceLabel
@onready var wallet_panel: VBoxContainer = $CenterContainer/RosterPanel/Content/WalletPanel
@onready var individual_contract_label: Label = $CenterContainer/RosterPanel/Content/WalletPanel/IndividualContractRow/IndividualContractLabel
@onready var ludus_contract_label: Label = $CenterContainer/RosterPanel/Content/WalletPanel/LudusContractRow/LudusContractLabel
@onready var accept_individual_contract_button: Button = $CenterContainer/RosterPanel/Content/WalletPanel/IndividualContractRow/AcceptIndividualContractButton
@onready var accept_ludus_contract_button: Button = $CenterContainer/RosterPanel/Content/WalletPanel/LudusContractRow/AcceptLudusContractButton
@onready var arena_button: Button = $CenterContainer/RosterPanel/Content/ArenaButton
@onready var title_label: Label = $CenterContainer/RosterPanel/Content/Title
@onready var center_container: CenterContainer = $CenterContainer
@onready var hub_plates: Control = $HubPlates
@onready var back_button: Button = $CenterContainer/RosterPanel/Content/BackButton
@onready var contracts_plate: Button = $HubPlates/ContractsPlate
@onready var roster_plate: Button = $HubPlates/RosterPlate
@onready var recruitment_plate: Button = $HubPlates/RecruitmentPlate
@onready var equipment_plate: Button = $HubPlates/EquipmentPlate
@onready var arena_plate: Button = $HubPlates/ArenaPlate

var active_panel: String = ""


func _ready() -> void:
	first_combatant_button.pressed.connect(_on_combatant_card_button_pressed.bind(0))
	second_combatant_button.pressed.connect(_on_combatant_card_button_pressed.bind(1))
	third_combatant_button.pressed.connect(_on_combatant_card_button_pressed.bind(2))
	sword_button.pressed.connect(_on_weapon_button_pressed.bind(LudusState.Weapon.SWORD))
	spear_button.pressed.connect(_on_weapon_button_pressed.bind(LudusState.Weapon.SPEAR))
	accept_individual_contract_button.pressed.connect(_on_accept_individual_contract_pressed)
	accept_ludus_contract_button.pressed.connect(_on_accept_ludus_contract_pressed)
	arena_button.pressed.connect(_on_arena_button_pressed)
	contracts_plate.pressed.connect(_on_contracts_plate_pressed)
	roster_plate.pressed.connect(_on_roster_plate_pressed)
	recruitment_plate.pressed.connect(_on_recruitment_plate_pressed)
	equipment_plate.pressed.connect(_on_equipment_plate_pressed)
	arena_plate.pressed.connect(_on_arena_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	LudusState.combatant_selected.connect(_on_combatant_selected)
	LudusState.weapon_selected.connect(_on_weapon_selected)
	LudusState.contracts_updated.connect(_refresh_contract_panel)
	if LudusState.has_selected_starting_candidate:
		center_container.visible = false
		hub_plates.visible = true
		_refresh_roster_display()
	else:
		_show_starting_candidate_selection()
	recruitment_plate.visible = _has_empty_roster_slot()
	_update_weapon_selection(LudusState.selected_weapon)
	_update_last_combat_result()
	_refresh_contract_panel()


func _show_starting_candidate_selection() -> void:
	active_panel = "initial"
	hub_plates.visible = false
	center_container.visible = true
	back_button.visible = false
	title_label.text = "Escolha seu gladiador inicial"
	subtitle_label.visible = true
	subtitle_label.text = "TRÊS ESCRAVOS DISPONÍVEIS"
	description_label.visible = true
	description_label.text = (
		"Compare as proficiências informativas e escolha um candidato para iniciar."
	)
	roster_container.visible = true
	selection_label.visible = false
	equipment_heading.visible = false
	equipment_options.visible = false
	weapon_selection_label.visible = false
	wallet_panel.visible = false
	last_combat_result_label.visible = false
	arena_button.visible = false
	recruitment_info_label.visible = false
	_set_combatant_cards_visible(true)

	var candidate_buttons: Array[Button] = [
		first_combatant_button,
		second_combatant_button,
		third_combatant_button,
	]
	var candidate_names: Array[Label] = [
		first_combatant_name,
		second_combatant_name,
		third_combatant_name,
	]
	var candidate_statuses: Array[Label] = [
		first_combatant_status,
		second_combatant_status,
		third_combatant_status,
	]
	var candidate_portraits: Array[TextureRect] = [
		first_combatant_portrait,
		second_combatant_portrait,
		third_combatant_portrait,
	]

	for candidate_index in range(LudusState.starting_candidates.size()):
		var candidate: Dictionary = LudusState.starting_candidates[candidate_index]
		candidate_names[candidate_index].text = candidate["name"]
		_set_card_portrait(candidate_portraits[candidate_index], candidate)
		candidate_statuses[candidate_index].text = (
			"Espada: %d/100\nLança: %d/100"
			% [candidate["sword_proficiency"], candidate["spear_proficiency"]]
		)
		candidate_buttons[candidate_index].text = "Escolher este"
		candidate_buttons[candidate_index].toggle_mode = true
		candidate_buttons[candidate_index].button_pressed = false
		candidate_buttons[candidate_index].disabled = false


func _on_combatant_card_button_pressed(card_index: int) -> void:
	if active_panel == "initial":
		_select_starting_candidate(card_index)
	elif active_panel == "recruitment":
		_purchase_recruitment_offer(card_index)
	elif card_index < LudusState.COMBATANT_NAMES.size():
		_on_combatant_button_pressed(LudusState.COMBATANT_NAMES[card_index])


func _select_starting_candidate(candidate_index: int) -> void:
	if not LudusState.select_starting_candidate(candidate_index):
		return
	_refresh_roster_display()
	center_container.visible = false
	hub_plates.visible = true
	recruitment_plate.visible = _has_empty_roster_slot()


func _set_combatant_cards_visible(is_visible: bool) -> void:
	first_combatant_card.visible = is_visible
	second_combatant_card.visible = is_visible
	third_combatant_card.visible = is_visible


func _refresh_roster_display() -> void:
	_set_combatant_cards_visible(true)
	var slot_names: Array[Label] = [
		first_combatant_name,
		second_combatant_name,
		third_combatant_name,
	]
	var slot_statuses: Array[Label] = [
		first_combatant_status,
		second_combatant_status,
		third_combatant_status,
	]
	var slot_portraits: Array[TextureRect] = [
		first_combatant_portrait,
		second_combatant_portrait,
		third_combatant_portrait,
	]
	var slot_buttons: Array[Button] = [
		first_combatant_button,
		second_combatant_button,
		third_combatant_button,
	]

	for slot_index in range(LudusState.COMBATANT_NAMES.size()):
		slot_buttons[slot_index].toggle_mode = true
		var slot_id: String = LudusState.COMBATANT_NAMES[slot_index]
		var slot: Dictionary = LudusState.get_roster_slot(slot_id)
		var candidate: Dictionary = slot.get("candidate", {})
		slot_names[slot_index].text = slot_id
		if candidate.is_empty():
			slot_statuses[slot_index].text = "Vaga vazia"
			slot_portraits[slot_index].texture = null
			slot_portraits[slot_index].visible = false
			slot_buttons[slot_index].visible = false
			continue

		_set_card_portrait(slot_portraits[slot_index], candidate)
		slot_statuses[slot_index].text = (
			"%s\nEspada: %d/100 | Lança: %d/100"
			% [
				candidate["name"],
				candidate["sword_proficiency"],
				candidate["spear_proficiency"],
			]
		)
		slot_buttons[slot_index].visible = true
		slot_buttons[slot_index].text = (
			"Selecionado para a próxima luta"
			if LudusState.selected_combatant == slot_id
			else "Selecionar"
		)
		slot_buttons[slot_index].disabled = false
		slot_buttons[slot_index].button_pressed = (
			LudusState.selected_combatant == slot_id
		)


func _set_card_portrait(portrait_rect: TextureRect, candidate: Dictionary) -> void:
	var portrait_id: int = candidate["portrait_id"]
	var portrait_path: String = (
		"res://art/portraits/Pixel_art_Portrait_%d.png" % portrait_id
	)
	var portrait_texture: Texture2D = load(portrait_path) as Texture2D
	assert(portrait_texture != null, "Não foi possível carregar o retrato: %s" % portrait_path)
	portrait_rect.texture = portrait_texture
	portrait_rect.visible = true


func _on_combatant_button_pressed(combatant_name: String) -> void:
	if not LudusState.select_combatant(combatant_name):
		return


func _on_combatant_selected(combatant_name: String) -> void:
	_update_selection(combatant_name)
	_refresh_roster_display()
	_refresh_contract_panel()


func _on_weapon_button_pressed(weapon: LudusState.Weapon) -> void:
	if not LudusState.select_weapon(weapon):
		return


func _on_weapon_selected(weapon: LudusState.Weapon) -> void:
	_update_weapon_selection(weapon)


func _on_accept_individual_contract_pressed() -> void:
	if not LudusState.accept_contract(LudusState.ContractType.INDIVIDUAL):
		return
	_refresh_contract_panel()


func _on_accept_ludus_contract_pressed() -> void:
	if not LudusState.accept_contract(LudusState.ContractType.LUDUS):
		return
	_refresh_contract_panel()


func _update_selection(combatant_name: String) -> void:
	first_combatant_button.button_pressed = combatant_name == "Gladiador 1"
	second_combatant_button.button_pressed = combatant_name == "Gladiador 2"
	third_combatant_button.button_pressed = combatant_name == "Gladiador 3"
	selection_label.text = "%s selecionado para a próxima luta." % combatant_name


func _update_weapon_selection(weapon: LudusState.Weapon) -> void:
	sword_button.button_pressed = weapon == LudusState.Weapon.SWORD
	spear_button.button_pressed = weapon == LudusState.Weapon.SPEAR
	weapon_selection_label.text = "Arma inicial: %s" % LudusState.get_selected_weapon_name()


func _update_last_combat_result() -> void:
	match LudusState.last_combat_result:
		LudusState.CombatResult.VICTORY:
			last_combat_result_label.text = "Última luta: Vitória"
			last_combat_result_label.visible = true
		LudusState.CombatResult.DEFEAT:
			last_combat_result_label.text = "Última luta: Derrota"
			last_combat_result_label.visible = true
		LudusState.CombatResult.NONE:
			last_combat_result_label.visible = false


func _refresh_contract_panel() -> void:
	balance_label.text = "Saldo: %d moedas" % LudusState.coins
	var individual_summary: Dictionary = LudusState.get_contract_summary(LudusState.ContractType.INDIVIDUAL)
	var ludus_summary: Dictionary = LudusState.get_contract_summary(LudusState.ContractType.LUDUS)
	individual_contract_label.text = individual_summary["status_text"]
	accept_individual_contract_button.text = individual_summary["button_text"]
	accept_individual_contract_button.disabled = individual_summary["accept_disabled"]
	ludus_contract_label.text = ludus_summary["status_text"]
	accept_ludus_contract_button.text = ludus_summary["button_text"]
	accept_ludus_contract_button.disabled = ludus_summary["accept_disabled"]


func _on_contracts_plate_pressed() -> void:
	_show_management_panel("contracts")


func _on_roster_plate_pressed() -> void:
	_refresh_roster_display()
	_show_management_panel("roster")


func _on_recruitment_plate_pressed() -> void:
	LudusState.prepare_recruitment_offers()
	_show_management_panel("recruitment")
	_refresh_recruitment_panel()


func _purchase_recruitment_offer(offer_index: int) -> void:
	if not LudusState.purchase_recruitment_offer(offer_index):
		return
	_refresh_recruitment_panel()
	recruitment_plate.visible = _has_empty_roster_slot()


func _refresh_recruitment_panel() -> void:
	var offers: Array[Dictionary] = LudusState.recruitment_offers
	var buttons: Array[Button] = [
		first_combatant_button,
		second_combatant_button,
		third_combatant_button,
	]
	var names: Array[Label] = [
		first_combatant_name,
		second_combatant_name,
		third_combatant_name,
	]
	var statuses: Array[Label] = [
		first_combatant_status,
		second_combatant_status,
		third_combatant_status,
	]
	var portraits: Array[TextureRect] = [
		first_combatant_portrait,
		second_combatant_portrait,
		third_combatant_portrait,
	]
	var cards: Array[PanelContainer] = [
		first_combatant_card,
		second_combatant_card,
		third_combatant_card,
	]
	var has_empty_slot: bool = _has_empty_roster_slot()

	for card_index in range(cards.size()):
		var has_offer: bool = card_index < offers.size()
		cards[card_index].visible = has_offer
		if not has_offer:
			continue

		var offer: Dictionary = offers[card_index]
		var is_purchased: bool = offer.get("is_purchased", false)
		buttons[card_index].toggle_mode = false
		buttons[card_index].button_pressed = false
		names[card_index].text = offer["name"]
		_set_card_portrait(portraits[card_index], offer)
		statuses[card_index].text = (
			"Espada: %d/100\nLança: %d/100"
			% [offer["sword_proficiency"], offer["spear_proficiency"]]
		)
		buttons[card_index].visible = true
		buttons[card_index].text = (
			"Contratado"
			if is_purchased
			else "Contratar — %d moedas" % LudusState.RECRUITMENT_COST
		)
		buttons[card_index].disabled = (
			is_purchased or not has_empty_slot or LudusState.coins < LudusState.RECRUITMENT_COST
		)

	recruitment_info_label.text = (
		"Saldo: %d moedas | Custo por contratação: %d moedas"
		% [LudusState.coins, LudusState.RECRUITMENT_COST]
	)


func _has_empty_roster_slot() -> bool:
	for combatant_name in LudusState.COMBATANT_NAMES:
		if LudusState.get_roster_slot(combatant_name).get("candidate", {}).is_empty():
			return true
	return false


func _on_equipment_plate_pressed() -> void:
	_show_management_panel("equipment")


func _on_back_button_pressed() -> void:
	center_container.visible = false
	hub_plates.visible = true


func _show_management_panel(panel_name: String) -> void:
	var show_contracts: bool = panel_name == "contracts"
	var show_roster: bool = panel_name == "roster"
	var show_recruitment: bool = panel_name == "recruitment"
	var show_equipment: bool = panel_name == "equipment"
	if not show_contracts and not show_roster and not show_recruitment and not show_equipment:
		push_error("Painel de gestão desconhecido: %s" % panel_name)
		return

	active_panel = panel_name
	hub_plates.visible = false
	center_container.visible = true
	back_button.visible = true
	title_label.text = (
		"Contratos"
		if show_contracts
		else "Elenco"
		if show_roster
		else "Contratar gladiadores"
		if show_recruitment
		else "Equipamento"
	)
	subtitle_label.visible = show_recruitment
	subtitle_label.text = "NOVOS ESCRAVOS DISPONÍVEIS"
	description_label.visible = show_roster or show_recruitment or show_equipment
	description_label.text = (
		"Selecione quem será preparado para a próxima luta."
		if show_roster
		else "Escolha um novo gladiador para ocupar uma vaga vazia."
		if show_recruitment
		else "Escolha a arma inicial para a próxima luta."
	)
	_set_combatant_cards_visible(show_roster or show_recruitment)
	roster_container.visible = show_roster or show_recruitment
	selection_label.visible = show_roster
	equipment_heading.visible = show_equipment
	equipment_options.visible = show_equipment
	weapon_selection_label.visible = show_equipment
	wallet_panel.visible = show_contracts
	recruitment_info_label.visible = show_recruitment
	last_combat_result_label.visible = (
		show_contracts and LudusState.last_combat_result != LudusState.CombatResult.NONE
	)
	arena_button.visible = false


func _on_arena_button_pressed() -> void:
	var result: Error = get_tree().change_scene_to_file(ARENA_SCENE)
	if result != OK:
		push_error("Não foi possível abrir a arena: %s" % error_string(result))
