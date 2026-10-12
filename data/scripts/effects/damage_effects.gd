# scripts/effects/damage_effect.gd
class_name DamageEffect
extends Effect

var amount: int
var damage_type: String

func _init(p_amount: int, p_damage_type: String) -> void:
	amount = p_amount
	damage_type = p_damage_type

func execute(context: EffectContext) -> void:
	if context.target_character:
		context.target_character.take_damage(amount, damage_type, context)
