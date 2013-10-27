root = window

root.Organization = class Organization extends root.UhelprResource

	$_propertyToJsonMapping:
		name       : 'name'
		description: 'description'
		address    : 'address'

	constructor: (
		@name        = null
		@description = null
		@address     = null
	) -> super