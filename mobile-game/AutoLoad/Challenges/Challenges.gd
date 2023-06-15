extends Node

func get_random_color() -> int:
	return Constants.StateEnum.values().duplicate().pick_random()
	
func get_color_name(value: int) -> String:
	return Constants.StateEnum.keys()[value].to_lower()
	
func pick_random_with_weight(values: Array[int], weight: Array[int]) -> int:
	var _values: Array = []
	for i in values.size():
		var value: int = values[i]
		for w in weight[i]:
			_values.append(value)
	return _values.pick_random()

enum States {
	WIN,
	LOSE,
	PASS
}

var getter: Dictionary= {
	'get_combo': get_combo,
	'get_match_color': get_match_color,
	'get_score_without_color': get_score_without_color,
	'get_match_in_row': get_match_in_row,
	'get_score': get_score
}

func get_combo(args: Dictionary = {}) -> Dictionary:
	var _combo: int = args.get('_combo', pick_random_with_weight([10, 20, 50], [5, 3, 2]))
	return {
		'args': {'name': 'get_combo', '_combo': _combo},
		'label': 'Do a combo %s' % _combo,
		'score': func () -> States:
			if Constants.combos_strike >= _combo:
				return States.WIN
			return States.PASS
	}

func get_match_color(args: Dictionary = {}) -> Dictionary:
	Session.challenge_args['counter'] = 0
	var _match: int = args.get('_match', pick_random_with_weight([5, 10, 15], [5, 3, 2]))
	var _color: int = args.get('_color', get_random_color())
	return {
		'args': {'name': 'get_match_color', '_match': _match, '_color': _color},
		'label': 'Match %s %s' % [_match, get_color_name(_color)],
		'score': func () -> States:
			if Session.character_state == _color:
				Session.challenge_args['counter'] += 1
			if Session.challenge_args['counter'] >= _match:
				return States.WIN
			return States.PASS
	}
	
func get_score_without_color(args: Dictionary = {}) -> Dictionary:
	var _score: int = args.get('_score', pick_random_with_weight([500, 1000, 5000], [5, 3, 2]))
	var _color: int = args.get('_color', get_random_color())
	return {
		'args': {'name': 'get_score_without_color', '_score': _score, '_color': _color},
		'label': 'Score %s without matching %s in a combo' % [_score, get_color_name(_color)],
		'score': func () -> States:
			if Constants.combos_strike >= 2 && Session.character_state == _color:
				return States.LOSE
			if Constants.score >= _score:
				return States.WIN
			return States.PASS
	}

func get_match_in_row(args: Dictionary = {}) -> Dictionary:
	Session.challenge_args['counter'] = 0
	var _match: int = args.get('_match', pick_random_with_weight([2, 3, 5], [5, 3, 2]))
	return {
		'args': {'name': 'get_match_in_row', '_match': _match},
		'label': 'Match %s in a row' % _match,
		'skip': func () -> States:
			Session.challenge_args['counter'] = 0
			return States.PASS,
		'score': func () -> States:
			Session.challenge_args['counter'] += 1
			if Session.challenge_args['counter'] >= _match:
				return States.WIN
			return States.PASS
	}
	
func get_score(args: Dictionary = {}) -> Dictionary:
	var _score: int = args.get('_score', pick_random_with_weight([1000, 10000, 50000], [5, 3, 2]))
	return {
		'args': {'name': 'get_score', '_score': _score},
		'label': 'Score %s' % _score,
		'score': func () -> States:
			if Constants.score >= _score:
				return States.WIN
			return States.PASS
	}
