root = window

class root.Organizations extends root.BaseResolvableController
	$_name: 'Organizations'

	$_dependencies: [ root.GoogleMapsApi ]

	constructor: ->
		super

		@$scope.$watch 'SiteState.$currentLocation.position', @currentLocationLatLngChanged, yes

	currentLocationLatLngChanged: ( newLatLng ) =>
		@$currentLatLng = newLatLng

	getMarkerOptions: ( location ) ->
		title   : location.name
		position: @GoogleMapsApi.geocodeAddress( location.address, @$currentLatLng ).then ( geocoderResults ) =>
			geocoderResults[ 0 ].geometry.location