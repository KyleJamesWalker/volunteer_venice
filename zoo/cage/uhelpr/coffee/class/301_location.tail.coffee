root = window

root.Location = class Location extends root.UhelprResource
	$_name: 'Location'

	$_propertyToJsonMapping:
		name: 'name'

	$_propertyToResourceMapping:
		position:
			lat_lng:
				root.LatLng

	constructor: (
		@name     = null
		@position = null
	) -> super

	$_fromJson: ->
		super
