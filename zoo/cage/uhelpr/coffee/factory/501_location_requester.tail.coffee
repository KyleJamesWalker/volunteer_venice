root = window

root.LocationRequester = class LocationRequester extends root.UhelprRequester
	$_name: 'LocationRequester'

	$_resourceClass: root.Location

	$_actions:
		getAll:
			method: 'GET'
			$_hasArray: yes

		getOne:
			method: 'GET'
			params:
				id: null

	$_actionDefaults:
		$_apiPath: '/location/:id'

	$_getResponseArray: ( responseData ) -> responseData.location

	$_getResponseObject: ( responseData ) -> responseData.location[ 0 ]

root.addFactory LocationRequester