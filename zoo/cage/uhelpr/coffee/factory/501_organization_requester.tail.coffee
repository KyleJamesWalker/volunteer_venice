root = window

root.OrganizationRequester = class OrganizationRequester extends root.UhelprRequester
	$_name: 'OrganizationRequester'

	$_resourceClass: root.Organization

	$_actions:
		getAll:
			method: 'GET'
			$_hasArray: yes

		getOne:
			method: 'GET'
			params:
				id: null

	$_actionDefaults:
		$_apiPath: '/organization/:id'

	$_getResponseArray: ( responseData ) -> responseData.organization

	$_getResponseObject: ( responseData ) -> responseData.organization[ 0 ]

root.addFactory OrganizationRequester