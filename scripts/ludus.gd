extends Control

const ARENA_SCENE: String = "res://scenes/arena.tscn"

@onready var first_combatant_button: Button = $CenterContainer/RosterPanel/Content/Roster/FirstCombatantCard/Content/SelectButton
@onready var second_combatant_button: Button = $CenterContainer/RosterPanel/Content/Roster/SecondCombatantCard/Content/SelectButton
@onready var subtitle_label: Label = $CenterContainer/RosterPanel/Content/Subtitle
@onready var description_label: Label = $CenterContainer/RosterPanel/Content/Description
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
@onready var equipment_plate: Button = $HubPlates/EquipmentPlate
@onready var arena_plate: Button = $HubPlates/ArenaPlate


func _ready() -> void:
	first_combatant_button.pressed.connect(_on_combatant_button_pressed.bind("Gladiador 1"))
	second_combatant_button.pressed.connect(_on_combatant_button_pressed.bind("Gladiador 2"))
	sword_button.pressed.connect(_on_weapon_button_pressed.bind(LudusState.Weapon.SWORD))
	spear_button.pressed.connect(_on_weapon_button_pressed.bind(LudusState.Weapon.SPEAR))
	accept_individual_contract_button.pressed.connect(_on_accept_individual_contract_pressed)
	accept_ludus_contract_button.pressed.connect(_on_accept_ludus_contract_pressed)
	arena_button.pressed.connect(_on_arena_button_pressed)
	contracts_plate.pressed.connect(_on_contracts_plate_pressed)
	roster_plate.pressed.connect(_on_roster_plate_pressed)
	equipment_plate.pressed.connect(_on_equipment_plate_pressed)
	arena_plate.pressed.connect(_on_arena_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	LudusState.combatant_selected.connect(_on_combatant_selected)
	LudusState.weapon_selected.connect(_on_weapon_selected)
	LudusState.contracts_updated.connect(_refresh_contract_panel)
	center_container.visible = false
	_update_selection(LudusState.selected_combatant)
	_update_weapon_selection(LudusState.selected_weapon)
	_update_last_combat_result()
	_refresh_contract_panel()


func _on_combatant_button_pressed(combatant_name: String) -> void:
	if not LudusState.select_combatant(combatant_name):
		return


func _on_combatant_selected(combatant_name: String) -> void:
	_update_selection(combatant_name)
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
	_show_management_panel("roster")


func _on_equipment_plate_pressed() -> void:
	_show_management_panel("equipment")


func _on_back_button_pressed() -> void:
	center_container.visible = false
	hub_plates.visible = true


func _show_management_panel(panel_name: String) -> void:
	var show_contracts: bool = panel_name == "contracts"
	var show_roster: bool = panel_name == "roster"
	var show_equipment: bool = panel_name == "equipment"
	if not show_contracts and not show_roster and not show_equipment:
		push_error("Painel de gestão desconhecido: %s" % panel_name)
		return

	hub_plates.visible = false
	center_container.visible = true
	title_label.text = "Contratos" if show_contracts else "Elenco" if show_roster else "Equipamento"
	subtitle_label.visible = false
	description_label.visible = not show_contracts
	description_label.text = (
		"Selecione quem será preparado para a próxima luta."
		if show_roster
		else "Escolha a arma inicial para a próxima luta."
	)
	roster_container.visible = show_roster
	selection_label.visible = show_roster
	equipment_heading.visible = show_equipment
	equipment_options.visible = show_equipment
	weapon_selection_label.visible = show_equipment
	wallet_panel.visible = show_contracts
	last_combat_result_label.visible = (
		show_contracts and LudusState.last_combat_result != LudusState.CombatResult.NONE
	)
	arena_button.visible = false


func _on_arena_button_pressed() -> void:
	var result: Error = get_tree().change_scene_to_file(ARENA_SCENE)
	if result != OK:
		push_error("Não foi possível abrir a arena: %s" % error_string(result))
