root = window

class OrganizationController extends root.BaseDirectiveController
	$_name: 'OrganizationController'

class Organization extends root.BaseDirective
	$_name: 'Organization'

	templateUrl: 'organization.html'

	controller: OrganizationController

	scope:
		organization     : '='
		onMapOrganization: '&'

root.addDirective Organization