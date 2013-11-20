root = window

class MapController extends root.BaseDirectiveController
	$_name: 'MapController'

	$_dependencies: [ root.GoogleMapsApi ]

	constructor: ->
		super

		@$scope.map = @GoogleMapsApi.makeMap( @$element[ 0 ], disableDefaultUI: yes ).then ( map ) => @$scope.map = map

class Map extends root.BaseDirective
	$_name: 'Map'

	controller: MapController

	scope:
		map: '='

root.addDirective Map