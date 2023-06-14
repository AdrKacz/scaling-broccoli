extends Node

func get_random_color() -> int:
	return Constants.StateEnum.values().duplicate().pick_random()
	
func get_color_name(value: int) -> String:
	return Constants.StateEnum.keys()[value].to_lower()
	
func pick_random_with_weight(values: Array[int], weight: Array[int]):
	var _values: Array = []
	for i in values.size():
		var value: int = values[i]
		for w in weight[i]:
			_values.append(value)
	return _values.pick_random()

var getter: Array[Callable] = [
	get_combo,
	get_match_color,
	get_score_without_color,
	get_match_in_row,
	get_score
]

func get_combo() -> Dictionary:
	var _combo: int = pick_random_with_weight([10, 20, 50], [5, 3, 2])
	return {
		'label': 'Do a combo %s' % _combo,
		'score': func (color: int) -> bool:
			if Constants.combos_strike >= _combo:
				return true
			return false
	}

func get_match_color() -> Dictionary:
	var _counter: int = 0
	var _match: int = pick_random_with_weight([5, 10, 15], [5, 3, 2])
	var _color: int = get_random_color()
	return {
		'label': 'Match %s %s' % [_match, get_color_name(_color)],
		'score': func (color: int) -> bool:
			if color == _color:
				_counter += 1
			if _counter >= _match:
				return true
			return false
	}
	
func get_score_without_color() -> Dictionary:
	var _score: int = pick_random_with_weight([500, 1000, 5000], [5, 3, 2])
	var _color: int = get_random_color()
	return {
		'label': 'Score %s without matching %s in a combo' % [_score, get_color_name(_color)],
		'score': func (color: int) -> bool:
			if Constants.combos_strike >= 2 && color == _color:
				return false
			if Constants.score >= _score:
				return true
			return false
	}

func get_match_in_row() -> Dictionary:
	var _counter: int = 0
	var _match: int = pick_random_with_weight([2, 3, 5], [5, 3, 2])
	return {
		'label': 'Match %s in a row' % _match,
		'miss': func (_color: int) -> bool:
			_counter = 0
			return false,
		'score': func (_color: int) -> bool:
			_counter += 1
			if _counter >= _match:
				return true
			return false
	}
	
func get_score() -> Dictionary:
	var _score: int = pick_random_with_weight([1000, 10000, 50000], [5, 3, 2])
	return {
		'label': 'Score %s' % _score,
		'score': func (_color: int) -> bool:
			if Constants.score >= _score:
				return true
			return false
	}
