extends Button
class_name ShieldButton

var inactive: bool:
	get:
		return $Shield.modulate.a == 1.0
	set(value):
		$Shield.modulate.a = 1.0 - 0.5 * float(value)

var outline: bool:
	get:
		return $Shield.self_modulate == Color.BLACK
	set(value):
		if value:
			$Shield.self_modulate = Color.BLACK
		else:
			$Shield.self_modulate = Color.WHITE
