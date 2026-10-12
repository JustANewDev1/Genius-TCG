# scripts/effects/effect_factory.gd
class_name EffectFactory
extends RefCounted

static func create(data: Dictionary) -> Effect:
	match data.get("type", ""):
		"damage":
			return DamageEffect.new(data.get("amount", 0), data.get("damage_type", "physical"))
		"conditional_damage":
			return ConditionalDamageEffect.new(
				data.get("amount", 0),
				data.get("damage_type", "physical"),
				data.get("condition", {})
			)
		# Add more later: heal, apply_status, create_summon, draw_cards...
		_:
			push_warning("Unknown effect type: " + str(data.get("type")))
			return null
