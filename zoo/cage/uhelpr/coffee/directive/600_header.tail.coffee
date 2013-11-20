root = window

class HeaderController extends root.BaseDirectiveController
	$_name: 'HeaderController'

	hovered: no

class Header extends root.BaseDirective
	$_name: 'Header'

	transclude: yes

	templateUrl: 'header.html'

	controller: HeaderController

root.addDirective Header