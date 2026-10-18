extends Node

signal combatant_selected(combatant_name: String)
signal weapon_selected(weapon: Weapon)
signal contracts_updated()

const COMBATANT_NAMES: PackedStringArray = ["Gladiador 1", "Gladiador 2"]
const STARTING_COINS: int = 100
const INDIVIDUAL_REWARD: int = 40
const LUDUS_REWARD_PER_VICTORY: int = 10
const LUDUS_COMPLETION_BONUS: int = 50
const LUDUS_TARGET_WINS: int = 3

enum Weapon {
	SWORD,
	SPEAR
}

enum CombatResult {
	NONE,
	VICTORY,
	DEFEAT
}

enum ContractType {
	INDIVIDUAL,
	LUDUS
}

var selected_combatant: String = COMBATANT_NAMES[0]
var selected_weapon: Weapon = Weapon.SWORD
var last_combat_result: CombatResult = CombatResult.NONE
var coins: int = STARTING_COINS
var contracts: Dictionary = {}


func _ready() -> void:
	_initialize_contracts()


func _initialize_contracts() -> void:
	contracts = {
		ContractType.INDIVIDUAL: {
			"name": "Contrato individual",
			"is_active": false,
			"is_complete": false,
			"linked_gladiator": "",
			"progress": 0,
			"reward_paid": false,
		},
		ContractType.LUDUS: {
			"name": "Contrato do Ludus",
			"is_active": false,
			"is_complete": false,
			"progress": 0,
			"reward_paid": false,
			"reward_total": 0,
		},
	}


func select_combatant(combatant_name: String) -> bool:
	if not COMBATANT_NAMES.has(combatant_name):
		push_error("Gladiador desconhecido selecionado: %s" % combatant_name)
		return false

	selected_combatant = combatant_name
	combatant_selected.emit(selected_combatant)
	return true


func select_weapon(weapon: Weapon) -> bool:
	match weapon:
		Weapon.SWORD, Weapon.SPEAR:
			selected_weapon = weapon
			weapon_selected.emit(selected_weapon)
			return true
		_:
			push_error("Arma inicial desconhecida selecionada: %d" % weapon)
			return false


func get_selected_weapon_name() -> String:
	match selected_weapon:
		Weapon.SWORD:
			return "ESPADA"
		Weapon.SPEAR:
			return "LANÇA"
		_:
			push_error("Arma inicial inválida no estado do Ludus.")
			return "ERRO"


func accept_contract(contract_type: ContractType) -> bool:
	var contract: Dictionary = get_contract_state(contract_type)
	if contract.is_empty():
		push_error("Contrato desconhecido selecionado: %d" % contract_type)
		return false

	if contract.get("is_active", false) or contract.get("is_complete", false):
		return false

	contract["is_active"] = true
	contract["is_complete"] = false
	contract["reward_paid"] = false

	match contract_type:
		ContractType.INDIVIDUAL:
			contract["linked_gladiator"] = selected_combatant
			contract["progress"] = 0
		ContractType.LUDUS:
			contract["progress"] = 0
			contract["reward_total"] = 0
		_:
			push_error("Tipo de contrato inválido ao aceitar: %d" % contract_type)
			return false

	contracts[contract_type] = contract
	contracts_updated.emit()
	return true


func get_contract_state(contract_type: ContractType) -> Dictionary:
	if not contracts.has(contract_type):
		return {}
	return contracts[contract_type]


func get_contract_summary(contract_type: ContractType) -> Dictionary:
	var contract: Dictionary = get_contract_state(contract_type)
	var status_text: String = "Disponível"
	var button_text: String = "Aceitar contrato"
	var accept_disabled: bool = false

	if contract.is_empty():
		return {
			"status_text": "Contrato indisponível",
			"button_text": "Indisponível",
			"accept_disabled": true,
		}

	if contract.get("is_complete", false):
		if contract_type == ContractType.INDIVIDUAL:
			status_text = "Concluído — %s venceu" % contract.get("linked_gladiator", "gladiador")
		else:
			status_text = "Concluído — %d/%d vitórias" % [contract.get("progress", 0), LUDUS_TARGET_WINS]
		button_text = "Contrato concluído"
		accept_disabled = true
	elif contract.get("is_active", false):
		if contract_type == ContractType.INDIVIDUAL:
			status_text = "Ativo — %s" % contract.get("linked_gladiator", "gladiador")
		else:
			status_text = "Ativo — %d/%d vitórias" % [contract.get("progress", 0), LUDUS_TARGET_WINS]
		button_text = "Contrato ativo"
		accept_disabled = true
	else:
		if contract_type == ContractType.INDIVIDUAL:
			status_text = "Disponível — vence com %s" % selected_combatant
			button_text = "Aceitar contrato individual"
		else:
			status_text = "Disponível — 3 vitórias acumuladas"
			button_text = "Aceitar contrato do Ludus"

	return {
		"status_text": status_text,
		"button_text": button_text,
		"accept_disabled": accept_disabled,
	}


func record_combat_result(player_won: bool) -> void:
	last_combat_result = CombatResult.VICTORY if player_won else CombatResult.DEFEAT
	if not player_won:
		return

	var individual_contract: Dictionary = get_contract_state(ContractType.INDIVIDUAL)
	if individual_contract.get("is_active", false) and not individual_contract.get("is_complete", false):
		if selected_combatant == individual_contract.get("linked_gladiator", ""):
			coins += INDIVIDUAL_REWARD
			individual_contract["is_active"] = false
			individual_contract["is_complete"] = true
			individual_contract["reward_paid"] = true
			individual_contract["progress"] = 1
			contracts[ContractType.INDIVIDUAL] = individual_contract
			contracts_updated.emit()

	var ludus_contract: Dictionary = get_contract_state(ContractType.LUDUS)
	if ludus_contract.get("is_active", false) and not ludus_contract.get("is_complete", false):
		ludus_contract["progress"] += 1
		coins += LUDUS_REWARD_PER_VICTORY
		ludus_contract["reward_total"] += LUDUS_REWARD_PER_VICTORY

		if ludus_contract["progress"] >= LUDUS_TARGET_WINS:
			coins += LUDUS_COMPLETION_BONUS
			ludus_contract["reward_total"] += LUDUS_COMPLETION_BONUS
			ludus_contract["is_active"] = false
			ludus_contract["is_complete"] = true
			ludus_contract["reward_paid"] = true

		ludus_contract["reward_paid"] = true
		contracts[ContractType.LUDUS] = ludus_contract
		contracts_updated.emit()


func clear_combat_result() -> void:
	last_combat_result = CombatResult.NONE
