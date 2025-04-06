extends Node2D

class_name StaminaComponent

signal stamina_depleted
signal stamina_recovered(amount: float)
signal stamina_changed(stamina: float)
signal stamina_consumed(amount: float)

@export var stamina: float = 100.0
@export var max_stamina: float = 100.0

@export var stamina_recovery_rate: float = 10
@export var stamina_on_use_cost: float = 30
@export var stamina_cost: float = 0


func consume_stamina(amount: float) -> void:
	if amount <= 0:
		return
	if amount > stamina:
		emit_signal("stamina_depleted")
		stamina = 0
	else:
		stamina -= amount
		emit_signal("stamina_consumed", amount)
		emit_signal("stamina_changed", stamina)
	pass

func recover_stamina(amount: float) -> void:
	if amount <= 0:
		return
	stamina += amount
	emit_signal("stamina_recovered", amount)
	emit_signal("stamina_changed", stamina)
	pass

func can_consume_stamina(amount: float) -> bool:
	return stamina >= amount
	pass

func is_stamina_depleted() -> bool:
	return stamina <= 0
	pass

func is_stamina_full() -> bool:
	return stamina >= 1
	pass




func _on_stamina_changed(stamina:float) -> void:
	%StaminaBar.value = stamina
	%StaminaBar.max_value = max_stamina
