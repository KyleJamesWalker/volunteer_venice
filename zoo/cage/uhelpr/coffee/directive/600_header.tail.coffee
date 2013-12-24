root = window

class HeaderController extends root.BaseDirectiveController
	$_name: 'HeaderController'

	hovered: no

class Header extends root.BaseTemplatedDirective
	$_name: 'Header'

	transclude: yes

	controller: HeaderController

root.addDirective Header