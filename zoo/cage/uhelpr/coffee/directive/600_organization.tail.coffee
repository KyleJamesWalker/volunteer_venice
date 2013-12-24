root = window

class OrganizationController extends root.BaseDirectiveController
	$_name: 'OrganizationController'

class Organization extends root.BaseTemplatedDirective
	$_name: 'Organization'

	controller: OrganizationController

	scope:
		organization     : '='
		onMapOrganization: '&'

root.addDirective Organization