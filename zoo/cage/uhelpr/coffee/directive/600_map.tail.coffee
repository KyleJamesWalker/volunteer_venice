root = window

class MapController extends root.BaseDirectiveController
	$_name: 'MapController'

	$_dependencies: [ root.GoogleMapsApi ]

	constructor: ->
		super

		@GoogleMapsApi.makeMap( @$element[ 0 ], disableDefaultUI: yes ).then ( @map ) =>

class Map extends root.BaseDirective
	$_name: 'Map'

	restrict: 'A'

	controller: MapController

root.addDirective Map