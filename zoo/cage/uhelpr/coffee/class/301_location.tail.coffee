root = window

root.Location = class Location extends root.UhelprResource

	$_propertyToJsonMapping:
		name: 'name'
		lat : 'lat'
		lng : 'lng'

	constructor: (
		@name = null
		@lat  = 'lat'
		@lng  = 'lng'
	) -> super