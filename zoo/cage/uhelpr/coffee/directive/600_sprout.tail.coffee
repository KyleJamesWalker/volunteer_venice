root = window

class Sprout extends root.BaseTemplatedDirective
	$_name: 'Sprout'

	scope:
		image: '='

root.addDirective Sprout