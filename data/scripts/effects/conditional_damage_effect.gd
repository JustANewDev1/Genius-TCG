# scripts/effects/conditional_damage_effect.gd
class_name ConditionalDamageEffect
extends Effect

var amount: int
var damage_type: String
var condition: Dictionary

func _init(p_amount: int, p_damage_type: String, p_condition: Dictionary) -> void:
	amount = p_amount
	damage_type = p_damage_type
	condition = p_condition

func execute(context: EffectContext) -> void:
	if _check_condition(context):
		if context.target_character:
			context.target_character.take_damage(amount, damage_type, context)

func _check_condition(context: EffectContext) -> bool:
	match condition.get("type", ""):
		"skill_use_count":
			var skill_id = condition.get("skill_id", context.skill_id)
			var every = condition.get("every", 1)
			var count = context.source_character.get_skill_use_count(skill_id)
			return count % every == 0
		_:
			return false
