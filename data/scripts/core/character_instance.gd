# scripts/core/character_instance.gd
class_name CharacterInstance
extends RefCounted

var data: CharacterCardData
var current_hp: int
var current_energy: int
var skill_use_counts: Dictionary = {}   # skill_id -> times used this duel

func _init(p_data: CharacterCardData) -> void:
	data = p_data
	current_hp = data.max_hp
	current_energy = 0

func get_skill_use_count(skill_id: String) -> int:
	return skill_use_counts.get(skill_id, 0)

func increment_skill_use(skill_id: String) -> void:
	skill_use_counts[skill_id] = get_skill_use_count(skill_id) + 1

func take_damage(amount: int, damage_type: String, context: EffectContext = null) -> void:
	# Later: shields, reactions, etc.
	current_hp = max(0, current_hp - amount)
	print("%s took %d %s damage (HP: %d)" % [data.name, amount, damage_type, current_hp])

func use_skill(character: CharacterInstance, skill_data: Dictionary, target: CharacterInstance) -> void:
	var skill_id: String = skill_data.id
	character.increment_skill_use(skill_id)

	var context = EffectContext.new()
	context.source_character = character
	context.target_character = target
	context.skill_id = skill_id

	for effect_dict in skill_data.effects:
		var effect = EffectFactory.create(effect_dict)
		if effect:
			effect.execute(context)
